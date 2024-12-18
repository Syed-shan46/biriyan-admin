import 'dart:convert';
import 'package:biriyan/constants/global_variables.dart';
import 'package:biriyan/models/banner.dart';
import 'package:biriyan/services/http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BannerController {
  uploadBanner({required dynamic pickedImage, required context}) async {
    try {
      final cloudinary = CloudinaryPublic("dwhidbfrj", "rhimclrg");
      CloudinaryResponse imageResponses = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(pickedImage,
              identifier: 'PickedImage', folder: 'Banners'));

      String image = imageResponses.secureUrl;

      BannerModel bannerModel = BannerModel(id: '', image: image);

      http.Response response = await http.post(
        Uri.parse('$uri/api/banner'),
        body: bannerModel.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Get.snackbar('Uploaded', 'Banner Uploaded Successfully');
          });
    } catch (e) {
      showSnackBar(context, 'Error $e');
    }
  }

  // Fetch banners
  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();

        return banners;
      } else {
        throw Exception('Failed to Load banners');
      }
    } catch (e) {
      throw Exception('Error loading Banners $e');
    }
  }

  Future<void> deleteBanner(String id) async {
    // Replace with your API call
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/dltbanner/$id'),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        jsonDecode(response.body);
        Get.snackbar('Deleted', 'Banner deleted Successfully',
            icon: const Icon(Icons.delete));
      } else if (response.statusCode == 404) {
        print("Error: ${jsonDecode(response.body)['error']}");
      } else {
        print("Failed to delete Banner. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
