import 'dart:convert';

import 'package:biriyan/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:biriyan/models/product.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductCardEditDelete extends StatefulWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCardEditDelete({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ProductCardEditDelete> createState() => _ProductCardEditDeleteState();
}

class _ProductCardEditDeleteState extends State<ProductCardEditDelete> {
  late bool _isSwitched;

  @override
  void initState() {
    super.initState();
    // Initialize the switch state based on the product's availability
    _isSwitched = widget.product.isAvailable;
  }

  void _toggleAvailability(bool value) {
    setState(() {
      _isSwitched = value;
    });
    widget.product.isAvailable = value;
    // Update the product's availability in the backend
    _updateProductAvailability(widget.product);
  }

  Future<void> _updateProductAvailability(Product product) async {
    try {
      // Example: Call your API to update the product's availability

      final url = Uri.parse(
          '$uri/api/product/${product.id}/availability'); // Your backend API URL

      try {
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'isAvailable':
                product.isAvailable, // The updated availability status
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          print('Product availability updated successfully');
        } else {
          print('Failed to update product: ${response.body}');
          Get.snackbar('Failed', 'Failed to update product availability');
        }
      } catch (error) {
        print('Error updating product: $error');
        Get.snackbar('Failed', 'Failed to update product availability');
      }

      print(
          'Product ${product.itemName} availability updated to: ${product.isAdditional}');
      // Perform API call here to update the product in the database
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product availability')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                    widget.product.images.isNotEmpty
                        ? widget.product.images[0]
                        : 'https://via.placeholder.com/80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price: ₹${widget.product.itemPrice}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  Switch(value: _isSwitched, onChanged: _toggleAvailability),
                  const SizedBox(height: 4),
                ],
              ),
            ),

            // Edit and Delete Actions
            Row(
              children: [
                IconButton(
                  onPressed: widget.onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Edit Product',
                ),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Product',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
