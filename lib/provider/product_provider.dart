import 'package:biriyan/controllers/productController.dart';
import 'package:biriyan/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductProvider extends StateNotifier<List<Product>> {
  ProductProvider() : super([]);
  final ProductController productController = ProductController();

  // Set the fetched products to the state
  void setProducts(List<Product> products) {
    state = products;
  }

  // Fetch products from the backend
  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await productController.loadProducts();
      setProducts(fetchedProducts);
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  // Delete a product from the list both locally and on the backend
  Future<void> deleteProduct(String id) async {
    try {
      // Delete the product from the backend
      await productController.deleteProductFromBackend(id);

      // If successful, update the local state
      state = state.where((product) => product.id != id).toList();
    } catch (error) {
      print('Error deleting product: $error');
      throw error;
    }
  }
}

final productProvider =
    StateNotifierProvider<ProductProvider, List<Product>>((ref) {
  return ProductProvider();
});
