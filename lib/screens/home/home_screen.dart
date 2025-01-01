import 'dart:convert';
import 'package:biriyan/constants/global_variables.dart';
import 'package:biriyan/controllers/order_controller.dart';
import 'package:biriyan/provider/order_provider.dart';
import 'package:biriyan/services/get_service_key.dart';
import 'package:biriyan/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  NotificationService notificationService = NotificationService();
  final GetServerKey _getServerKey = GetServerKey();
  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    getServiceToken();
    _fetchProcessingOrders();
  }

  Future<List<Map<String, dynamic>>> loadOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/all-orders/'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>(); // Cast to a list of maps
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading orders: $e'); // Logs detailed error
      throw Exception('Error loading orders: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    // Call your loadOrders function
    return loadOrders();
  }

  Future<void> getServiceToken() async {
    String serverToken = await _getServerKey.getServerKeyToken();
    print("Server Token => $serverToken");
  }

  // Fetch Orders
  Future<void> _fetchOrders() async {
    final orderController = OrderController();
    try {
      final orders = await orderController.loadOrders();
      ref.read(orderProvider.notifier).setOrders(orders);

      // Initialize button states
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  // Processing orders
  Future<void> _fetchProcessingOrders() async {
    final orderController = OrderController();
    try {
      final orders = await orderController.processingOrders();
      ref.read(orderProvider.notifier).setOrders(orders);

      // Initialize button states
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  // API Call for Accepting Order
  Future<void> _acceptOrder(String orderId, int index) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/api/accept-order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'orderId': orderId}),
      );

      if (response.statusCode == 200) {
        print('Order accepted successfully.');
        // Remove the order from the list
        ref.read(orderProvider.notifier).removeOrder(orderId);
      } else {
        print('Error accepting order: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // API Call for Accepting Order
  Future<void> _cancelOrder(String orderId, int index) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/api/cancel-order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'orderId': orderId}),
      );

      if (response.statusCode == 200) {
        print('Order Cancelled successfully.');
        ref.read(orderProvider.notifier).removeOrder(orderId);
      } else {
        print('Error Cancelling order: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final products = (order['products'] as List<dynamic>? ?? []);

              return Card(
              color: Colors.white,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Order ID: ${order['_id'] is Map ? order['_id']['\$oid'] : order['_id']}'),
                      Text('Phone: ${order['phone']}'),
                      Text('Total Amount: ₹${order['totalAmount']}'),
                      Text('Order Status: ${order['orderStatus']}'),
                      const SizedBox(height: 10),
                      Text('Products:',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      ...products.map((product) {
                        return Text(
                            '- ${product['productName']} (x${product['quantity']})');
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
