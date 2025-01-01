import 'dart:convert';

import 'package:biriyan/constants/global_variables.dart';
import 'package:biriyan/provider/product_provider.dart';
import 'package:biriyan/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:biriyan/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ProductCardEditDelete extends ConsumerStatefulWidget {
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
  ConsumerState<ProductCardEditDelete> createState() =>
      _ProductCardEditDeleteState();
}

class _ProductCardEditDeleteState extends ConsumerState<ProductCardEditDelete> {
  late bool _isSwitched;
  late IO.Socket socket; // Declare the socket variable

  @override
  void initState() {
    super.initState();
    // Initialize the switch state based on the product's availability
    _isSwitched = widget.product.isAvailable;
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'], // Use WebSocket transport
      'autoConnect': false, // Disable autoConnect to manually handle connection
    });

    // Listen for the socket connection
    socket.on('connect', (_) {
      print('Connected to WebSocket');
    });

    // Listen for product updates from the server (replace with your event)
    socket.on('productUpdated', (data) {
      print('Product updated: $data');
      // You can add logic to update your product list here
      ref.read(productProvider.notifier).fetchProducts();
    });

    // Manually connect to the socket
    socket.connect();
  }

  @override
  void dispose() {
    // Close the socket connection when the screen is disposed
    socket.disconnect();
    super.dispose();
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
      final url = Uri.parse('$uri/api/product/${product.id}/availability');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isAvailable': product.isAvailable}),
      );

      if (response.statusCode == 200) {
        print('Product availability updated successfully');
        Get.snackbar('Success', 'Product availability updated');
      } else {
        print('Failed to update product: ${response.body}');
        Get.snackbar('Status code', 'Failed to update product availability');
      }
    } catch (error) {
      print('Error updating product: $error');
      Get.snackbar('Failed', 'Failed to update product availability');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
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
                    widget.product.itemName[0],
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
                  Switch(
                      activeColor: AppColors.primaryColor.withOpacity(0.7),
                      value: _isSwitched,
                      thumbColor: const WidgetStatePropertyAll(Colors.white),
                      onChanged: _toggleAvailability),
                  const SizedBox(height: 4),
                ],
              ),
            ),

            // Edit and Delete Actions
            Row(
              children: [
                IconButton(
                  onPressed: widget.onEdit,
                  icon: Icon(Icons.edit,
                      color: AppColors.primaryColor.withOpacity(0.8)),
                  tooltip: 'Edit Product',
                ),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: Icon(Icons.delete, color: Colors.red.withOpacity(0.8)),
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
