import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_order_qr_menu/Core/Routes/app_routes.dart';
import 'package:self_order_qr_menu/Core/Theme/app_palette.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_cubit.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_state.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Screens/detailed_item.dart';
import 'package:shimmer/shimmer.dart';

import '../../Domain/entities/add_to_cart_entity.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final random = Random();
  late final int randomDigit;
  late List<AddToCartEntity> cartItems;

  @override
  void initState() {
    super.initState();
    randomDigit = random.nextInt(900000) + 100000;
    cartItems = context.read<CartCubit>().getItems()!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingData = screenWidth > 600
        ? EdgeInsets.symmetric(horizontal: screenWidth * .1)
        : const EdgeInsets.symmetric(horizontal: 10);

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is ItemAdded ||
            state is ItemRemoved ||
            state is ItemModified) {
          setState(() {
            cartItems = context.read<CartCubit>().getItems()!;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppPalette.offWhite,
        appBar: AppBar(
          title: const Text(
            "Checkout Cart",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: paddingData,
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, spreadRadius: 1, blurRadius: 6),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Table No. 12",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const DottedLine(dashColor: Colors.black26),
                    const SizedBox(height: 8),
                    Text("Order ID: #$randomDigit",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) =>
                      _buildCartItems(cartItems[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItems(AddToCartEntity item) {
    List<String?>? customizationOptions = item.selectedCustomization?.values
        .toList()
        .map((val) => val?.name)
        .toList();
    String? variationOptions = item.selectedVariation?.name;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 6),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              _showQuantity(item.quantity),
              const SizedBox(width: 15),
              _showProductImage(item.productImage ?? ""),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productCategoryName ?? "", // Category name
                      style: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        item.productName, // Product name
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (variationOptions != null && variationOptions.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                            color: AppPalette.offWhite,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          variationOptions, // Variation name
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    if (customizationOptions != null &&
                        customizationOptions.isNotEmpty)
                      Wrap(
                        spacing: 4.0,
                        children: customizationOptions
                            .where((option) => option != null)
                            .map((option) => Container(
                                  decoration: BoxDecoration(
                                      color: AppPalette.offWhite,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  child: Text(
                                    option!,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${(item.productPrice * item.quantity).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Colors.teal.shade400,
                              fontWeight: FontWeight.w600),
                        ),
                        _buildAddButton(item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 1,
            right: 1,
            child: GestureDetector(
              onTap: () {
                // Call the delete method on item
                context.read<CartCubit>().removeItemFromCart(item);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppPalette.offWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.red,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showQuantity(int quantity) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.teal.shade100,
        boxShadow: const [
          BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 2),
        ],
      ),
      child: Text(
        "x${quantity.toInt()}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _showProductImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 60,
            height: 60,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error, size: 60),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAddButton(AddToCartEntity item) {
    final cartCubit = context.read<CartCubit>();
    final cartItem = cartCubit.getSingleItemById(item.productId);
    int itemCount = item.quantity;

    if (cartItem != null && itemCount == 0) {
      itemCount = cartItem.quantity;
    }

    return Container(
      width: 85,
      height: 35,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1.5,
          color: Colors.teal.shade800,
        ),
      ),
      child: itemCount > 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (itemCount > 1) {
                      setState(() {
                        itemCount--;
                      });
                      final updatedItem = AddToCartEntity(
                        productId: item.productId,
                        productName: item.productName,
                        categoryId: item.categoryId,
                        productCategoryName: item.productCategoryName,
                        productImage: item.productImage,
                        productPrice: item.productPrice,
                        selectedCustomization: item.selectedCustomization,
                        selectedVariation: item.selectedVariation,
                        quantity: itemCount,
                      );
                      cartCubit.modifyCartItem(cartItem!, updatedItem);
                    } else {
                      cartCubit.removeItemFromCart(item);
                    }
                  },
                  child: const Icon(Icons.remove, color: Colors.teal, size: 18),
                ),
                Text(
                  "$itemCount",
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      itemCount++;
                    });
                    final updatedItem = AddToCartEntity(
                      productId: item.productId,
                      productName: item.productName,
                      productCategoryName: item.productCategoryName,
                      productImage: item.productImage,
                      productPrice: item.productPrice,
                      selectedCustomization: item.selectedCustomization,
                      selectedVariation: item.selectedVariation,
                      quantity: itemCount,
                      categoryId: item.categoryId,
                    );
                    cartCubit.modifyCartItem(cartItem!, updatedItem);
                  },
                  child: const Icon(Icons.add, color: Colors.teal, size: 18),
                ),
              ],
            )
          : const Center(
              child: Text(
                "Add",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
