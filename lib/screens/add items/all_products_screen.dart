import 'package:biriyan/models/product.dart';
import 'package:biriyan/provider/product_provider.dart';
import 'package:biriyan/screens/add%20items/add_product_screen.dart';
import 'package:biriyan/screens/add%20items/edit_product_screen.dart';
import 'package:biriyan/screens/add%20items/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class AllProductsScreen extends ConsumerStatefulWidget {
  const AllProductsScreen({super.key});

  @override
  ConsumerState<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends ConsumerState<AllProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the initial product list when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchProducts();
    });
  }

  // Function to show delete confirmation dialog
  void _showDeleteDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismiss on tapping outside the dialog
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${product.itemName}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              try {
                await ref
                    .read(productProvider.notifier)
                    .deleteProduct(product.id);

                Get.snackbar('Deleted', 'Deleted ${product.itemName}',
                    icon: const Icon(Icons.delete));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete ${product.itemName}'),
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the product list from the provider
    final products = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
              onPressed: () => Get.to(() => AddProductScreen()),
              icon: const Icon(Icons.add))
        ],
      ),
      body: products.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: products.length, // Ensure this is properly initialized
              itemBuilder: (context, index) {
                // Debugging logs
                print('Products length: ${products.length}');
                print('Index being accessed: $index');

                if (index >= products.length) {
                  return SizedBox.shrink();
                }

                final product = products[index];
                return ProductCardEditDelete(
                  product: product,
                  onEdit: () {
                    print('Edit product: ${product.itemName}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    _showDeleteDialog(context, product);
                  },
                );
              },
            ),
    );
  }
}
