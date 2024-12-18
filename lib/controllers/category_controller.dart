import 'dart:convert';
import 'package:biriyan/constants/global_variables.dart';
import 'package:biriyan/models/category.dart';
import 'package:biriyan/services/http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  uploadCategory({
    required dynamic pickedImage,
    required String name,
    required context,
  }) async {
    // Upload Categories

    try {
      final cloudinary = CloudinaryPublic("dwhidbfrj", "rhimclrg");

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'Picked Image', folder: 'Category images'),
      );

      String image = imageResponse.secureUrl;

      Category category = Category(id: '', name: name, image: image);

      http.Response response = await http.post(
        Uri.parse("$uri/api/category"),
        body: category.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Get.snackbar('Uploaded', "Category Uploaded",
              icon: const Icon(Icons.upload_file));
        },
      );
    } catch (e) {
      print("Error uploading category: $e"); // Debug print for errors
      Get.snackbar(context, 'Error: $e');
    }
  }

  // Fetch categories
  Future<List<Category>> loadCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Category> categories =
            data.map((category) => Category.fromJson(category)).toList();
        return categories;
      } else {
        throw Exception('Failed to Load Categories');
      }
    } catch (e) {
      throw Exception('Error loading Categories $e');
    }
  }

  // Delete Category
  Future<void> deleteCategory(String id) async {
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/deletectgry/$id'),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        jsonDecode(response.body);
        Get.snackbar('Delete', 'Category deleted Successfully',
            icon: const Icon(Icons.delete));
      } else if (response.statusCode == 404) {
        print("Error: ${jsonDecode(response.body)['error']}");
      } else {
        print("Failed to delete category. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
