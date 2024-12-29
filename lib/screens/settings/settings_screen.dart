import 'package:biriyan/provider/product_provider.dart';
import 'package:biriyan/screens/add%20items/all_products_screen.dart';
import 'package:biriyan/screens/settings/accepted_orders_screen.dart';
import 'package:biriyan/screens/settings/cancelled_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the initial product list when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                SizedBox(
                  height: 45,
                  child: Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue),
                        onPressed: () {
                          Get.to(() => const AcceptedScreen());
                        },
                        child: const Text('Accepted Orders')),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 45,
                  child: Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue),
                        onPressed: () {
                          Get.to(() => const CancelledScreen());
                        },
                        child: const Text('Cancelled Orders')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45,
                  child: Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue),
                        onPressed: () {
                          Get.to(() => const AllProductsScreen());
                        },
                        child: const Text('Products')),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 45,
                  child: Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue),
                        onPressed: () {
                          Get.to(() => const AllProductsScreen());
                        },
                        child: const Text('Categories')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45,
                  child: Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue),
                        onPressed: () {
                          Get.to(() => const AllProductsScreen());
                        },
                        child: const Text('Categories')),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
