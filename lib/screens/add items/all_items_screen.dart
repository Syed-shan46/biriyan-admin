import 'package:biriyan/provider/product_provider.dart';
import 'package:biriyan/screens/add%20items/all_products_screen.dart';
import 'package:biriyan/screens/add%20items/banner_screen.dart';
import 'package:biriyan/screens/add%20items/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class AllItemsScreen extends ConsumerStatefulWidget {
  const AllItemsScreen({super.key});

  @override
  ConsumerState<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends ConsumerState<AllItemsScreen> {
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
        title: const Text('Add Items'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const AllProductsScreen());
                },
                child: const Text('Products'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const CategoryScreen()),
                child: const Text('Categories'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const BannerScreen()),
                child: const Text('Banners'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
