import 'package:biriyan/controllers/nav_controller.dart';
import 'package:biriyan/screens/add%20items/all_products_screen.dart';
import 'package:biriyan/screens/home/home_screen.dart';
import 'package:biriyan/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  final BottomNavController navController = Get.put(BottomNavController());

  final List<Widget> screens = [
    const OrderScreen(),
    const AllProductsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
          screens[navController.currentIndex.value]), // Observe current index
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          elevation: 20,
          selectedItemColor: const Color(0xff579BB1),
          unselectedItemColor: Colors.blueGrey.shade300,
          backgroundColor: const Color(0xff1A1A1D),

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
