import 'package:biriyan/constants/global_variables.dart';
import 'package:biriyan/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProductScreen extends StatefulWidget {
  final Product product; // Pass the Product ID to the EditScreen
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController priceController = TextEditingController();

  // Function to handle the API call to update the price
  Future<void> updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
          '$uri/api/products/${widget.product.id}'); // Replace with actual backend URL
      try {
        final response = await http.put(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "itemPrice": int.parse(priceController.text),
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Price updated successfully')),
          );
        } else {
          throw Exception('Failed to update the price');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    priceController.text = widget.product.itemPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the updated price';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProduct,
                child: const Text('Update Price'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
