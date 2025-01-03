import 'package:biriyan/controllers/nav_controller.dart';
import 'package:biriyan/screens/add%20items/all_products_screen.dart';
import 'package:biriyan/screens/home/home_screen.dart';
import 'package:biriyan/screens/settings/settings_screen.dart';
import 'package:biriyan/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  final BottomNavController navController = Get.put(BottomNavController());

  final List<Widget> screens = [
    const OrderScreen(),
    const AllProductsScreen(),
    const OrderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
          screens[navController.currentIndex.value]), // Observe current index
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          elevation: 20,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          backgroundColor: AppColors.primaryColor.withOpacity(0.7),

          currentIndex: navController.currentIndex.value,
          onTap: navController.updateIndex, // Update index on tap
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upload_outlined),
              label: 'Upload',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
