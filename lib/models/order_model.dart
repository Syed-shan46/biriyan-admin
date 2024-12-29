import 'dart:convert';

class Order {
  final String id; // Order ID (MongoDB _id)
  final String userId;
  final String name;
  final String phone;
  final String address;
  final String productName;
  final int quantity;
  final String category;
  final String image;
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
    return Order(
      id: map['_id'] as String? ?? '', // MongoDB _id is typically returned as '_id'
      userId: map['userId'] as String? ?? '',
      name: map['userName'] as String? ?? '',
      phone: map['phone']?.toString() ?? '', // Convert phone to String
      address: map['address'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      quantity: map['quantity'] is int
          ? map['quantity'] as int
          : int.tryParse(map['quantity'].toString()) ??
              0, // Handle int and String
      category: map['category'] as String? ?? '',
      image: map['image'] as String? ?? '',
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
