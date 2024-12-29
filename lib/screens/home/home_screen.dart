import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:biriyan/constants/global_variables.dart';
import 'package:biriyan/controllers/order_controller.dart';
import 'package:biriyan/models/order_model.dart';
import 'package:biriyan/provider/order_provider.dart';
import 'package:biriyan/services/get_service_key.dart';
import 'package:biriyan/services/notification_service.dart';
import 'package:biriyan/services/send_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
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
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders found now'),
            )
          : ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Product Image
                                  Container(
                                    width: 65,
                                    height: 65,
                                    decoration: BoxDecoration(
                                      color: Colors.cyan.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(order.image),
                                  ),
                                  const SizedBox(width: 16),

                                  // Order Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Category
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.cyan
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(order.category),
                                            ),

                                            // Total Price
                                            Text(
                                              '₹${order.totalAmount}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),

    
                                        // Product Name
                                        Text(
                                          order.productName,
                                        ),
                                        const SizedBox(height: 4),

                                        // Quantity
                                        Text('Quantity: ${order.quantity}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Delivery Address
                              Text(
                                'Delivery Address',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),

                              const SizedBox(height: 4),
                              Text('To: ${order.name}'),
                              Text('${order.phone}, ${order.address}'),
                              const SizedBox(height: 10),

                              // Accept and Cancel Buttons
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red.withOpacity(0.9),
                                    ),
                                    onPressed: () async {
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            icon: Icon(
                                              Icons.warning,
                                              color:
                                                  Colors.red.withOpacity(0.8),
                                              size: 45,
                                            ),
                                            title: const Text('Cancel Order'),
                                            content: const Text(
                                                'Are you sure you want to Cancel this order?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false); // No
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  SendNotificationService
                                                      .sendNotificationUsingApi(
                                                          token: order
                                                              .customerDeviceToken,
                                                          title:
                                                              'Order Cancelled',
                                                          body:
                                                              'Your Order is Cancelled');
                                                  Navigator.of(context)
                                                      .pop(true); // Yes
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      ).then((confirmed) async {
                                        if (confirmed == true) {
                                          await _cancelOrder(order.id, index);
                                        }
                                      });
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.blue.withOpacity(0.9),
                                    ),
                                    onPressed: () async {
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Accept Order'),
                                            content: const Text(
                                                'Are you sure you want to accept this order?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false); // No
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  SendNotificationService
                                                      .sendNotificationUsingApi(
                                                          token: order
                                                              .customerDeviceToken,
                                                          title:
                                                              'Order Accepted',
                                                          body:
                                                              'Your order is accepted ');
                                                  Navigator.of(context)
                                                      .pop(true); // Yes
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      ).then((confirmed) async {
                                        if (confirmed == true) {
                                          await _acceptOrder(order.id, index);
                                        }
                                      });
                                    },
                                    child: const Text(
                                      'Accept',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
