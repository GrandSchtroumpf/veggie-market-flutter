import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../service.dart';

class Order {
  final String id;
  final DocumentReference ref;
  DateTime time = DateTime.now();
  List<OrderItem> items;
  String email;
  double price;

  Order({
    this.id,
    this.ref,
    this.items,
    this.time,
    this.email,
  });

  factory Order.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return Order.fromJson(snapshot.data(), snapshot.reference);
    }
    return null;
  }

  Order.fromJson(Map<String, dynamic> data, DocumentReference ref)
      : id = ref.id,
        ref = ref,
        email = data['email'],
        time = data['time'],
        items = data['items'].map((item) => OrderItem.fromJson(item)).toList();

  Map<String, dynamic> toJson() => {
        'email': email,
        'time': time,
        'items': items.map((item) => item.toJson()).toList()
      };
}

class OrderItem {
  /// Price at the date of the order
  double unitPrice;
  String productId;
  int amount;

  OrderItem(this.productId, this.amount);
  OrderItem.fromJson(Map<String, dynamic> item)
      : productId = item['productId'],
        amount = item['amount'];

  Map<String, dynamic> toJson() => {'productId': productId, 'amount': amount};
}

class OrderConverter extends Converter<Order> {
  @override
  Order fromFirestore(DocumentSnapshot snapshot) {
    return Order.fromJson(snapshot.data(), snapshot.reference);
  }

  @override
  Map<String, dynamic> toFirestore(Order data) {
    return data.toJson();
  }
}
