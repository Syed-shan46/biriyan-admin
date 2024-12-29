import 'dart:convert';
import 'dart:io';
import 'package:biriyan/constants/global_variables.dart';
import 'package:biriyan/models/product.dart';
import 'package:biriyan/services/http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ProductController {
  void uploadProduct({
    required String productName,
    required int productPrice,
    int? quantity,
    required String description,
    required String category,
    required List<File> pickedImages,
    required bool isAdditional,
    required bool isAvailable,
    required context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic("dwhidbfrj", "rhimclrg");
      List<String> images = [];
      for (var i = 0; i < pickedImages.length; i++) {
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
        );
        images.add(cloudinaryResponse.secureUrl);
      }

      if (category.isNotEmpty) {
        final Product product = Product(
            isAvailable: true,
            id: 'id',
            itemName: productName,
            isAdditional: isAdditional,
            itemPrice: productPrice,
            quantity: 1,
            description: description,
            category: category,
            images: images);

        http.Response response = await http.post(
          Uri.parse('$uri/api/add-product'),
          body: product.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
        );

        manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Get.snackbar('Uploaded', "Product uploaded",
                icon: const Icon(Icons.upload_file));
          },
        );
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  void updateProduct({
    required bool isAvailable,
    required String productId,
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required List<File> pickedImages,
    required bool isAdditional,
    required context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic("dwhidbfrj", "rhimclrg");
      List<String> images = [];

      // Upload images to Cloudinary
      for (var i = 0; i < pickedImages.length; i++) {
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
        );
        images.add(cloudinaryResponse.secureUrl);
      }

      if (category.isNotEmpty) {
        final Product updatedProduct = Product(
          isAvailable: isAvailable,
          id: productId,
          itemName: productName,
          isAdditional: isAdditional,
          itemPrice: productPrice,
          description: description,
          category: category,
          images: images,
        );

        http.Response response = await http.put(
          Uri.parse('$uri/api/products/$productId'),
          body: updatedProduct.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
        );

        manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Get.snackbar(
              'Updated',
              "Product updated successfully.",
              icon: const Icon(Icons.edit),
            );
          },
        );
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  Future<List<Product>> loadProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();

        return products;
      } else {
        throw Exception('Failed to Load Products');
      }
    } catch (e) {
      throw Exception('Error loading Products $e');
    }
  }

  // Fetch Product by ID
  Future<Product> fetchProduct(String id) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/$id'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed , Error: $e');
    }
  }

  // Function to delete a product from the backend
  Future<void> deleteProductFromBackend(String productId) async {
    final response = await http.delete(
      Uri.parse('$uri/api/products/$productId'),
    );

    if (response.statusCode == 200) {
      // Product deleted successfully
      print('Product deleted from backend');
    } else {
      // Handle the error from the backend
      throw Exception('Failed to delete product from backend');
    }
  }

  
}
