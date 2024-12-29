import 'dart:convert';
import 'package:biriyan/constants/global_variables.dart';
import 'package:biriyan/controllers/order_controller.dart';
import 'package:biriyan/models/order_model.dart';
import 'package:biriyan/provider/order_provider.dart';
import 'package:biriyan/services/get_service_key.dart';
import 'package:biriyan/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CancelledScreen extends ConsumerStatefulWidget {
  const CancelledScreen({super.key});

  @override
  ConsumerState<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends ConsumerState<CancelledScreen> {
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();

    _cancelledOrders();
  }

  // Accepted orders
  Future<void> _cancelledOrders() async {
    final orderController = OrderController();
    try {
      final orders = await orderController.cancelledOrders();
      ref.read(orderProvider.notifier).setOrders(orders);

      // Initialize button states
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Cancelled Orders')),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              order.productName,
                                            ),
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(1),
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Text(order.orderStatus))
                                          ],
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
