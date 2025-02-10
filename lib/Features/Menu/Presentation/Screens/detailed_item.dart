import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:self_order_qr_menu/Core/Routes/app_routes.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_cubit.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_state.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/menu_cubit/menu_cubit.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Screens/cart_screen.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Screens/menu_screen.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Widgets/detailed%20page/item_info_chip.dart';
import '../../Domain/entities/add_to_cart_entity.dart';
import '../../Domain/entities/category_entity.dart';
import '../../Domain/entities/product_customization_entity.dart';
import '../../Domain/entities/product_entity.dart';
import '../Widgets/detailed page/custom_text_field.dart';
import '../Widgets/detailed page/variation_customization_widget.dart';
import '../Widgets/veg_nonVeg_Icon.dart';

class DetailedItem extends StatefulWidget {
  final ProductEntity cardItem;
  final CategoryEntity category;
  final ProductCustomizationEntity? customization;

  const DetailedItem({
    super.key,
    required this.cardItem,
    required this.category,
    this.customization,
  });

  @override
  State<DetailedItem> createState() => _DetailedItemState();
}

class _DetailedItemState extends State<DetailedItem> {
  double customizationPrice = 0;
  int quantity = 1;
  final _textController = TextEditingController();
  late double _itemTotalPrice;
  Map<String, OptionsEntity?>? _selectedCustomization;
  VariationEntity? _selectedVariation;
  AddToCartEntity? _addToCartItem;
  late int _numberOfCartItem;

  @override
  void initState() {
    super.initState();
    // _fetchItemDetails();
    _initializeDefaultValues();
    _fetchCartItem();
  }

  //Initialize the values
  void _initializeDefaultValues() {
    _itemTotalPrice = widget.cardItem.basePrice;
    _selectedVariation = null;
    _selectedCustomization = {};
    _numberOfCartItem = context.read<CartCubit>().getItems()?.length ?? 0;
  }

  void _fetchCartItem() {
    _addToCartItem =
        context.read<CartCubit>().getSingleItemById(widget.cardItem.productId);
    if (_addToCartItem != null) {
      _textController.text = _addToCartItem?.addInstructions ?? "";
      _selectedVariation = _addToCartItem?.selectedVariation;
      _selectedCustomization = _addToCartItem?.selectedCustomization ?? {};
      quantity = _addToCartItem?.quantity ?? 1;
    } else {
      _textController.text = "";
      quantity = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingData = screenWidth > 600
        ? EdgeInsets.symmetric(horizontal: screenWidth * .1)
        : const EdgeInsets.symmetric(horizontal: 0);

    return BlocListener<MenuCubit, MenuState>(
      listener: (context, state) {
        if (state is MenuSelectVariation) {
          setState(() {
            _selectedVariation = state.selectedVariation!;
            _itemTotalPrice = state.selectedVariation!.price;
          });
        }
        if (state is MenuSelectCustomization) {
          setState(() {
            _selectedCustomization = state.data;
            _updateCustomizationPrice();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: paddingData,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              _buildDetailsSection(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildBottomBar(screenWidth, paddingData),
      ),
    );
  }

  void _updateCustomizationPrice() {
    customizationPrice = _selectedCustomization?.values.fold(
          widget.cardItem.basePrice,
          (total, option) => total! + (option?.price ?? 0),
        ) ??
        widget.cardItem.basePrice;
    _itemTotalPrice = customizationPrice;
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.teal,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.cardItem.imageUrl.isNotEmpty
                  ? widget.cardItem.imageUrl.first
                  : "https://images.pexels.com/photos/3421920/pexels-photo-3421920.jpeg?auto=compress&cs=tinysrgb&w=600",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            AppRoutes.pushReplacement(context, const CartScreen());
          },
          icon: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_bag_outlined,
                    color: Colors.black),
              ),
              Positioned(
                right: 2,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _numberOfCartItem == 0
                        ? Colors.transparent
                        : Colors.red,
                  ),
                  child: Text(
                    "${_numberOfCartItem == 0 ? "" : _numberOfCartItem}",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItemHeader(),
              const SizedBox(height: 20),
              _buildInfoChips(),
              const SizedBox(height: 15),
              _buildDescription(),
              const SizedBox(height: 15),
              if (widget.cardItem.isCustomizable ||
                  widget.cardItem.hasVariation)
                VariationCustomizationWidget(
                  productId: widget.cardItem.productId,
                  customization: widget.customization,
                  variations: widget.cardItem.variations,
                ),
              const SizedBox(height: 10),
              _buildAddNoteSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemHeader() {
    return Row(
      children: [
        Row(
          children: [
            if (widget.cardItem.isVeg) buildVegNonVegIcon(true),
            if (widget.cardItem.isNonVeg) buildVegNonVegIcon(false),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.cardItem.name,
            maxLines: 2,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.cardItem.basePrice != 0)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              "₹${widget.cardItem.basePrice}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.teal,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildInfoChip(Icons.food_bank_outlined, widget.category.categoryName),
        buildInfoChip(Icons.local_fire_department_rounded, "450cal"),
        buildInfoChip(Icons.timer_outlined, "10-15 min"),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const Divider(),
        ReadMoreText(
          widget.cardItem.description,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54),
          trimMode: TrimMode.Line,
          trimLines: 2,
          colorClickableText: Colors.pink,
          trimCollapsedText: 'Show more',
          trimExpandedText: ' Show less',
          moreStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
          lessStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ],
    );
  }

  Widget _buildAddNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add Note",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 10),
        customTextField(_textController),
      ],
    );
  }

  Widget _buildBottomBar(double screenWidth, EdgeInsets paddingData) {
    final cartCubit = context.read<CartCubit>();
    return Padding(
      padding: paddingData,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTotalPriceSection(),
            const SizedBox(width: 20),
            _buildAddToCartSection(cartCubit),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPriceSection() {
    final cartCubit = context.read<CartCubit>();
    final currentItem = cartCubit.getSingleItemById(widget.cardItem.productId);

    if (currentItem != null) {
      final selectedCustomization = currentItem.selectedCustomization;
      final selectedVariation = currentItem.selectedVariation;
      if (selectedCustomization != null) {
        double customizationPrice = 0;
        for (var item in selectedCustomization.values) {
          customizationPrice += item!.price;
        }
        _itemTotalPrice = _itemTotalPrice + customizationPrice;
      } else if (selectedVariation != null) {
        _itemTotalPrice = selectedVariation.price;
      }

      _itemTotalPrice = currentItem.productPrice;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Total Price",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
        ),
        Text(
          "₹${customizationPrice == 0 ? (quantity > 0 ? _itemTotalPrice * quantity : _itemTotalPrice) : (quantity > 0 ? customizationPrice * quantity : customizationPrice)}",
          style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 24, color: Colors.teal),
        ),
      ],
    );
  }

  Widget _buildAddToCartSection(CartCubit cartCubit) {
    return Expanded(
      child: quantity == 0
          ? ElevatedButton(
              onPressed: widget.cardItem.isOutOfStock ? null : _handleAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.cardItem.isOutOfStock ? Colors.grey : Colors.teal,
                foregroundColor: widget.cardItem.isOutOfStock
                    ? Colors.black87
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.cardItem.isOutOfStock ? "Out Of Stock" : "Add To Cart",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            )
          : Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.teal.shade600,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _decrementQuantity,
                    icon:
                        const Icon(Icons.remove, color: Colors.white, size: 20),
                    splashRadius: 20,
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _incrementQuantity,
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                    splashRadius: 20,
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addItemToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal.shade600,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Add",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _handleAddToCart() {
    if ((widget.cardItem.hasVariation && _selectedVariation == null) ||
        (widget.cardItem.isCustomizable && _selectedCustomization!.isEmpty)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: 'Select Item',
        desc: 'Select at least one item',
        autoHide: const Duration(seconds: 3),
      ).show();
    } else {
      setState(() => quantity++);
    }
  }

  void _addItemToCart() {
    try {
      // Check if the item is already in the cart
      final item = context
          .read<CartCubit>()
          .getSingleItemById(widget.cardItem.productId);
      final productToAdd = _getProductToBeAdded();

      if (item != null) {
        // If the item is already in the cart, modify it
        context.read<CartCubit>().modifyCartItem(item, productToAdd);
      } else {
        // If the item is not in the cart, add it
        context.read<CartCubit>().addItemToCart(productToAdd);
      }

      setState(() {
        _numberOfCartItem = context.read<CartCubit>().getItems()?.length ?? 0;
      });

      // Show a success dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        title: item != null ? 'Updated' : 'Added',
        desc:
            '${productToAdd.quantity} x ${productToAdd.productName} ${item != null ? 'updated in' : 'added to'} the cart',
        btnCancelText: "Go to Cart",
        btnOkText: "Add More",
        btnCancelOnPress: () =>
            AppRoutes.pushReplacement(context, const CartScreen()),
        btnOkOnPress: () =>
            AppRoutes.pushReplacement(context, const MenuScreen()),
      ).show();
    } catch (e) {
      // Handle errors and show a user-friendly message
      print("Error: ${e.toString()}");
    }
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity == 1) {
        final item = context
            .read<CartCubit>()
            .getSingleItemById(widget.cardItem.productId);
        if (item != null) context.read<CartCubit>().removeItemFromCart(item);

        //update number of cart Item
        _numberOfCartItem = context.read<CartCubit>().getItems()?.length ?? 0;
      }
      if (quantity > 0) quantity--;
    });
  }

  void _incrementQuantity() {
    setState(() => quantity++);
  }

  AddToCartEntity _getProductToBeAdded() {
    final baseEntity = AddToCartEntity(
      productId: widget.cardItem.productId,
      categoryId: widget.cardItem.categoryId,
      productName: widget.cardItem.name,
      productCategoryName: widget.category.categoryName,
      productImage: widget.cardItem.imageUrl.isNotEmpty
          ? widget.cardItem.imageUrl[0]
          : null,
      quantity: quantity,
      productPrice: widget.cardItem.basePrice,
      addInstructions: _textController.text,
    );

    if (widget.cardItem.hasVariation) {
      return baseEntity.copyWith(
        productPrice: _selectedVariation?.price,
        selectedVariation: _selectedVariation,
      );
    } else if (widget.cardItem.isCustomizable) {
      return baseEntity.copyWith(
        productPrice: _itemTotalPrice,
        selectedCustomization: _selectedCustomization,
      );
    } else {
      return baseEntity;
    }
  }
}
