import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_order_qr_menu/Core/Routes/app_routes.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_cubit.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_state.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Screens/cart_screen.dart';

import '../../../../Core/Common/Widgets/cart_icon_button.dart';

AppBar mainAppBar(double screenWidth, BuildContext context) {
  return AppBar(
    elevation: 0,
    toolbarHeight: 100,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade600,
            Colors.tealAccent.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    automaticallyImplyLeading: false,
    // Ensures no default menu icon
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        screenWidth > 600
            ? SizedBox(
                width: screenWidth * 0.1,
              )
            : const SizedBox(
                width: 16,
              ),
        // App Logo or Icon
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.restaurant_menu,
            color: Colors.teal,
            size: 28,
          ),
        ),
        const SizedBox(width: 10),
        // App Name and Tagline
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Brew Haven",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
            Text(
              "Coffee & Restaurant",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ],
    ),
    actions: [
      // Cart Icon with Badge
      BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          int itemCount = 0;
          if (state is ItemModified ||
              state is ItemAdded ||
              state is ItemRemoved) {
            itemCount = context.read<CartCubit>().getItems()?.length ?? 0;
          }
          return GestureDetector(
            onTap: () {
              AppRoutes.push(context, const CartScreen());
            },
            child: Padding(
              padding: screenWidth > 600
                  ? EdgeInsets.only(right: screenWidth * 0.1)
                  : const EdgeInsets.only(right: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CartIconButton(),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor:
                          itemCount == 0 ? Colors.transparent : Colors.red,
                      child: Text(
                        itemCount == 0 ? "" : "$itemCount",
                        // Replace with dynamic cart count
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
}
