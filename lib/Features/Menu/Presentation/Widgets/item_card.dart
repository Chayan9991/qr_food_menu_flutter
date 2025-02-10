import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_order_qr_menu/Core/Routes/app_routes.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_customization_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_state.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Screens/detailed_item.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Widgets/veg_nonVeg_Icon.dart';
import '../../../../Core/Theme/app_palette.dart';
import '../../Domain/entities/add_to_cart_entity.dart';
import '../Cubits/cart_cubits/cart_cubit.dart';

class ItemCard extends StatefulWidget {
  final ProductEntity cardItem;
  final CategoryEntity category;
  final ProductCustomizationEntity? productCustomization;

  const ItemCard({
    super.key,
    required this.cardItem,
    required this.category,
    this.productCustomization,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int itemCount = 0;

  void _navigateToDetailedPage(BuildContext context) {
    AppRoutes.push(
        context,
        DetailedItem(
          cardItem: widget.cardItem,
          category: widget.category,
          customization: widget.cardItem.isCustomizable
              ? widget.productCustomization
              : null,
        ));
  }

  @override
  Widget build(BuildContext context) {
    const cardHeight = 237;

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final isItemInCart = context
                .read<CartCubit>()
                .getSingleItemById(widget.cardItem.productId) !=
            null;

        if (cartState is ItemRemoved && !isItemInCart) {
          itemCount = 0;
        }

        return Container(
          width: 160,
          decoration: BoxDecoration(
            color: AppPalette.offWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _navigateToDetailedPage(context),
                child: Stack(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        imageUrl: (widget.cardItem.imageUrl.isNotEmpty)
                            ? widget.cardItem.imageUrl.first
                            : "https://images.pexels.com/photos/3421920/pexels-photo-3421920.jpeg?auto=compress&cs=tinysrgb&w=600",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: cardHeight * .5,
                        placeholder: (context, url) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: AppPalette.tealGreen),
                          );
                        },
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),
                    ),

                    // Veg/Non-Veg Icon
                    if (widget.cardItem.isVeg || widget.cardItem.isNonVeg)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Row(
                          children: [
                            if (widget.cardItem.isVeg) buildVegNonVegIcon(true),
                            if (widget.cardItem.isVeg &&
                                widget.cardItem.isNonVeg)
                              const SizedBox(width: 4),
                            if (widget.cardItem.isNonVeg)
                              buildVegNonVegIcon(false),
                          ],
                        ),
                      ),

                    // Added Banner
                    if (isItemInCart) _buildAddedBanner(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.category.categoryName,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          "15 Min",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.cardItem.name,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.cardItem.basePrice != 0
                              ? "₹${widget.cardItem.basePrice.toStringAsFixed(2)}"
                              : "Select Variations",
                          style: TextStyle(
                            fontSize: widget.cardItem.basePrice != 0 ? 14 : 12,
                            color: widget.cardItem.isOutOfStock
                                ? Colors.grey
                                : Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildAddButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddButton() {
    final cartCubit = context.read<CartCubit>();
    // Fetch the current item from the cart (if it exists)
    final cartItem = cartCubit.getSingleItemById(widget.cardItem.productId);

    // Initialize itemCount based on the cart state
    if (cartItem != null && itemCount == 0) {
      itemCount = cartItem.quantity;
    }

    if (widget.cardItem.isCustomizable || widget.cardItem.hasVariation) {
      return GestureDetector(
        onTap: () => {
          if (!widget.cardItem.isOutOfStock) {_navigateToDetailedPage(context)}
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: widget.cardItem.isOutOfStock
                  ? Colors.grey
                  : Colors.teal.shade800,
            ),
          ),
          child: Center(
            child: Text(
              "Add",
              style: TextStyle(
                color: widget.cardItem.isOutOfStock ? Colors.grey : Colors.teal,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          if (itemCount == 0) {
            setState(() => itemCount = 1);
            cartCubit.addItemToCart(AddToCartEntity(
              productId: widget.cardItem.productId,
              categoryId: widget.cardItem.categoryId,
              productName: widget.cardItem.name,
              productCategoryName: widget.category.categoryName,
              productPrice: widget.cardItem.basePrice,
              productImage: widget.cardItem.imageUrl.isNotEmpty
                  ? widget.cardItem.imageUrl.first
                  : "",
              quantity: 1,
            ));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: itemCount > 0 ? 75 : 40,
          height: 30,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Colors.teal.shade800,
            ),
          ),
          child: itemCount > 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final oldItem = cartCubit
                            .getSingleItemById(widget.cardItem.productId);
                        if (itemCount > 0) {
                          setState(() {
                            itemCount--;
                          });
                          if (oldItem != null && itemCount > 0) {
                            cartCubit.modifyCartItem(
                                oldItem,
                                AddToCartEntity(
                                  productId: widget.cardItem.productId,
                                  productName: widget.cardItem.name,
                                  categoryId: widget.cardItem.categoryId,
                                  productCategoryName:
                                      widget.category.categoryName,
                                  productPrice: widget.cardItem.basePrice,
                                  productImage:
                                      widget.cardItem.imageUrl.isNotEmpty
                                          ? widget.cardItem.imageUrl.first
                                          : "",
                                  quantity: itemCount,
                                ));
                          } else {
                            final item = cartCubit
                                .getSingleItemById(widget.cardItem.productId);
                            //remove item
                            if (item != null) {
                              cartCubit.removeItemFromCart(item);
                            }
                          }
                        }
                      },
                      child: const Icon(Icons.remove,
                          color: Colors.teal, size: 18),
                    ),
                    Text(
                      "$itemCount",
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => itemCount++);
                        final oldItem = cartCubit
                            .getSingleItemById(widget.cardItem.productId);
                        if (oldItem != null) {
                          cartCubit.modifyCartItem(
                            oldItem,
                            AddToCartEntity(
                              productId: widget.cardItem.productId,
                              productName: widget.cardItem.name,
                              categoryId: widget.cardItem.categoryId,
                              productPrice: widget.cardItem.basePrice,
                              productCategoryName: widget.category.categoryName,
                              productImage: widget.cardItem.imageUrl.isNotEmpty
                                  ? widget.cardItem.imageUrl.first
                                  : "",
                              quantity: itemCount,
                            ),
                          );
                        }
                      },
                      child:
                          const Icon(Icons.add, color: Colors.teal, size: 18),
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
        ),
      );
    }
  }

  Widget _buildAddedBanner() {
    return Positioned(
      top: 8,
      right: 8,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.teal, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 10,
            ),
            SizedBox(width: 4),
            Text(
              "Added",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
