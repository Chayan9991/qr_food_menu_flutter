import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_order_qr_menu/Core/Theme/app_palette.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_cubit.dart';
import 'package:self_order_qr_menu/init_dependency.dart';
import 'Features/Auth/Presentation/Screens/account_screen.dart';
import 'Features/Menu/Presentation/Cubits/menu_cubit/menu_cubit.dart';
import 'Features/Menu/Presentation/Screens/cart_screen.dart';
import 'Features/Menu/Presentation/Screens/menu_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => serviceLocator<CartCubit>(),
    ),
    BlocProvider(
      create: (context) => serviceLocator<MenuCubit>(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}

class AnimatedBottomNavBar extends StatefulWidget {
  const AnimatedBottomNavBar({super.key});

  @override
  _AnimatedBottomNavBarState createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar> {
  int _currentIndex = 0;

  // List of pages for navigation.
  final List<Widget> _pages = [
    const MenuScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: screenWidth < 600 // Condition to check screen width
          ? BottomNavigationBar(
              onTap: _onItemTapped,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey.shade600,
              backgroundColor: AppPalette.offWhite,
              currentIndex: _currentIndex,
              items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded), label: "Menu"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart), label: "Cart"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle), label: "Account"),
                ])
          : null, // Hide bottom navigation bar on wider screens
    );
  }
}
