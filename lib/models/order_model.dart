import 'dart:convert';

import 'package:biriyan/models/product.dart';

class Order {
  final String id; // Order ID (MongoDB _id)
  final String userId;
  final String name;
  final String phone;
  final String address;
  final List<String> productName;
  final List<int> quantity; // Changed to int
  final List<String> category;
  final List<String> image; // Changed to List<Product>
  final int totalAmount;
  final String paymentStatus;
  final String orderStatus;
  final bool delivered;
  final String customerDeviceToken;

  Order({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.productName,
    required this.quantity,
    required this.category,
    required this.image,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.delivered,
    required this.customerDeviceToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'image': image,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'delivered': delivered,
      'customerDeviceToken': customerDeviceToken
    };
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(Map<String, dynamic> map) {
    // Deserialize each product into a Product object
    var productList = (map['products'] as List)
        .map((productMap) => Product.fromJson(productMap))
        .toList();

    return Order(
      id: map['_id'] as String? ??
          '', // MongoDB _id is typically returned as '_id'
      userId: map['userId'] as String? ?? '',
      name: map['userName'] as String? ?? '',
      phone: map['phone']?.toString() ?? '', // Convert phone to String
      address: map['address'] as String? ?? '',
      productName: List<String>.from(map['productName'] ?? []),
      quantity: List<int>.from(map['quantity'] ?? []),
      category: List<String>.from(map['category'] ?? []),
      image: List<String>.from(map['image'] ?? []),
      totalAmount: map['totalAmount'] is int
          ? map['totalAmount'] as int
          : int.tryParse(map['totalAmount'].toString()) ??
              0, // Handle int and String
      paymentStatus: map['paymentStatus'] as String? ?? 'Pending',
      orderStatus: map['orderStatus'] as String? ?? 'Pending',
      customerDeviceToken: map['customerDeviceToken'] as String? ?? '',
      delivered: map['delivered'] == true ||
          map['delivered'] == 'true' ||
          map['delivered'] == 1,
    );
  }
}
