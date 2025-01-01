import 'dart:convert';
import 'package:biriyan/constants/global_variables.dart';
import 'package:biriyan/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrderController {
  // All orders
  Future<List<Order>> loadOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/all-orders/'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading orders: $e'); // Logs detailed error
      throw Exception('Error loading orders: $e');
    }
  }

  Future<List<Order>> processingOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/processing-orders/'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check if the 'orders' key exists and is a list
        if (data['orders'] is List) {
          final List<dynamic> orders = data['orders'];
          // Convert each order in the list to an Order object
          return orders.map((order) => Order.fromJson(order)).toList();
        } else {
          throw Exception(
              'Expected "orders" to be a list, but got: ${data['orders']}');
        }
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading processing orders: $e');
      throw Exception('Error loading processing orders: $e');
    }
  }

  Future<List<Order>> acceptedOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/accepted-orders/'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Access the list of orders using the correct key
        final List<dynamic> orders = data['orders'];
        return orders.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading accepted orders: $e'); // Logs detailed error
      throw Exception('Error accepted processing orders: $e');
    }
  }

  Future<List<Order>> cancelledOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/cancelled-orders/'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Access the list of orders using the correct key
        final List<dynamic> orders = data['orders'];
        return orders.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading Cancelled orders: $e'); // Logs detailed error
      throw Exception('Error loading Cancelled orders: $e');
    }
  }
}
