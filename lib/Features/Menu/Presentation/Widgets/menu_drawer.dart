import 'package:flutter/material.dart';
import 'package:self_order_qr_menu/Core/Routes/app_routes.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header with Elegant Styling
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.teal.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.local_cafe, size: 30, color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Brew Haven Coffee & Bistro",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "123 Java Lane, Bean City, CA",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(Icons.account_circle, "Account", context),
                _buildDrawerItem(Icons.menu_book, "Menu", context),
                _buildDrawerItem(Icons.shopping_cart, "Cart", context),
                _buildDrawerItem(Icons.info_outline, "About Us", context),
              ],
            ),
          ),

          // Footer Section
          const Divider(thickness: 1, color: Colors.teal),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    AppRoutes.removeContext(context);
                  },
                  icon: const Icon(Icons.cancel, size: 30, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  "Developed by Chayan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Drawer Item Builder
  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal.shade700),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: Colors.teal.withOpacity(0.1),
    );
  }
}
