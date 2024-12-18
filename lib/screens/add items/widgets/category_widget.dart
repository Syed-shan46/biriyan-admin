import 'package:biriyan/controllers/category_controller.dart';
import 'package:biriyan/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryWidget extends ConsumerStatefulWidget {
  const CategoryWidget({
    super.key,
  });

  @override
  ConsumerState<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends ConsumerState<CategoryWidget> {
  final CategoryController categoryController = CategoryController();
  Future<void> _fetchCategories() async {
    try {
      final categories = await categoryController.loadCategories();
      ref.read(categoryProvider.notifier).setCategories(categories);
    } catch (e) {
      print('Error $e');
    }
  }

  Future<void> _deleteCategory(String id) async {
    try {
      await categoryController.deleteCategory(id);
      // Refresh categories after deletion
      await _fetchCategories();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Column(
                children: [
                  InkWell(
                    onTap: () async {
                      // ignore: unused_local_variable
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Product'),
                            content: const Text(
                                'Are you sure you want to delete this product?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false); // User pressed "No"
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await _deleteCategory(category.id);
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 235, 235),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // Load image from network instead of assets
                        child: Image.network(
                          category
                              .image, // Assuming Category model has imageUrl field
                          width: 45,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error); // Error fallback
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(category.name), // Show category name
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
