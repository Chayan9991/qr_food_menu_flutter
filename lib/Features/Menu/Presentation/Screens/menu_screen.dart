import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:self_order_qr_menu/Core/Theme/app_palette.dart';
import 'package:self_order_qr_menu/Features/Menu/Data/datasources/local/shared_prefs_service.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_customization_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/menu_cubit/menu_cubit.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Widgets/main_app_bar.dart';
import '../Widgets/custom_carousel.dart';
import '../Widgets/item_card.dart';
import '../Widgets/menu_drawer.dart';
import '../Widgets/menu_category_chip.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final SharedPrefsService sharedPrefsService =
      GetIt.instance<SharedPrefsService>();

  int _selectedIndex = 0;
  CategoryEntity? _selectedCategory;
  bool? _isVegSelected;
  List<CategoryEntity>? _categories;
  Map<String, List<ProductEntity>>? _categoryProductMap;
  List<ProductEntity>? _allProductsList;
  List<ProductEntity>? _selectedCategoryProductsList;
  List<ProductCustomizationEntity>? _customizationList;

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().loadMenuData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppPalette.offWhite,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     sharedPrefsService.clearCache();
      //   },
      //   child: const Icon(Icons.refresh),
      // ),
      appBar: mainAppBar(screenWidth, context),
      drawer: const MenuDrawer(),
      body: BlocConsumer<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Message: ${state.getMessage}")),
            );
          }
        },
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuLoaded) {
            _categories = state.menuResult.categoryList;
            _categoryProductMap = state.menuResult.categoryToProductMap;
            _customizationList = state.menuResult.productCustomizationList;

            // Populate _allProductsList with all products
            _allProductsList = _categoryProductMap?.values
                .expand((products) => products)
                .toList();
          }

          return CustomScrollView(
            slivers: [
              // Non-Sticky Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: screenWidth > 600
                      ? EdgeInsets.symmetric(horizontal: screenWidth * .1)
                      : const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Trending Items🔥",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CarouselWidget(),
                      const SizedBox(height: 12),
                      _buildSearchBar(),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),

              // Sticky Header
              SliverPersistentHeader(
                delegate: _StickyHeaderDelegate(
                  child: Container(
                    color: AppPalette.offWhite,
                    padding: screenWidth > 600
                        ? EdgeInsets.symmetric(horizontal: screenWidth * .1)
                        : const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Categories🔥",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCategoryChips(),
                        const SizedBox(height: 10),
                        const Divider(thickness: 1),
                        _buildMenuHeader(),
                      ],
                    ),
                  ),
                ),
                pinned: true,
                floating: false,
              ),

              // Scrollable Grid Content
              SliverPadding(
                padding: screenWidth > 600
                    ? EdgeInsets.symmetric(horizontal: screenWidth * .1)
                    : const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.74,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final List<ProductEntity>? sourceList =
                          _selectedIndex == 0
                              ? _allProductsList
                              : _selectedCategoryProductsList;

                      final filteredList = _isVegSelected != null
                          ? sourceList
                              ?.where((item) => item.isVeg == _isVegSelected)
                              .toList()
                          : sourceList;

                      final item = filteredList?.elementAt(index);

                      if (item == null) {
                        return const SizedBox();
                      }

                      final customization = _customizationList?.firstWhere(
                        (val) => val.categoryId == item.categoryId,
                        orElse: () => ProductCustomizationEntity(
                            categoryId: '', optionData: []),
                      );

                      final category = _categories?.firstWhere(
                        (cat) => cat.categoryId == item.categoryId,
                      );

                      return ItemCard(
                        cardItem: item,
                        category: category!,
                        productCustomization: customization,
                      );
                    },
                    childCount: () {
                      final List<ProductEntity>? sourceList =
                          _selectedIndex == 0
                              ? _allProductsList
                              : _selectedCategoryProductsList;

                      return _isVegSelected != null
                          ? sourceList
                                  ?.where(
                                      (item) => item.isVeg == _isVegSelected)
                                  .length ??
                              0
                          : sourceList?.length ?? 0;
                    }(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 4)
      ]),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search Your Food",
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black38),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 43,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (_categories?.length ?? 0) + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                  _selectedCategory = null;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: MenuCategoryChip(
                  isSelected: _selectedIndex == 0,
                  item: 'All',
                  gradient: _selectedIndex == index
                      ? const LinearGradient(
                          colors: [Colors.teal, Colors.green],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                ),
              ),
            );
          }

          final categoryIndex = index - 1;
          final category = _categories![categoryIndex];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
                _selectedCategory = category;
                _selectedCategoryProductsList =
                    _categoryProductMap?[category.categoryId];
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: MenuCategoryChip(
                isSelected: _selectedIndex == index,
                item: category.categoryName,
                gradient: _selectedIndex == index
                    ? const LinearGradient(
                        colors: [Colors.teal, Colors.green],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedCategory?.categoryName ?? "- All Items -",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade700,
            fontSize: 15,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              _buildVegButton(),
              const SizedBox(width: 8),
              _buildNonVegButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVegButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _isVegSelected = _isVegSelected == true ? null : true;
        });
      },
      icon: const Icon(
        Icons.check_circle_outline,
        size: 14,
        color: Colors.green,
      ),
      label: const Text(
        "Veg",
        style: TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: _isVegSelected == true ? Colors.green : Colors.white,
            width: 2,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
    );
  }

  Widget _buildNonVegButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _isVegSelected = _isVegSelected == false ? null : false;
        });
      },
      icon: const Icon(
        Icons.check_circle_outline,
        size: 14,
        color: Colors.red,
      ),
      label: const Text(
        "Non-Veg",
        style: TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: _isVegSelected == false ? Colors.red : Colors.white,
            width: 2,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 164;

  @override
  double get minExtent => 164;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
