import 'package:biriyan/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  void setOrders(List<Order> orders) {
    state = orders;
  }

  void removeOrder(String orderId) {
    state = state.where((order) => order.id != orderId).toList();
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>((ref) {
  return OrderProvider();
});
