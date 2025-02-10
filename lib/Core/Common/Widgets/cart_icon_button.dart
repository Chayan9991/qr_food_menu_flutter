import 'package:flutter/material.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Screens/cart_screen.dart';
import '../../Routes/app_routes.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.teal.shade400,
      child: const Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    );
  }
}
