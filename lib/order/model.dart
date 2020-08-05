import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../service.dart';

class Order {
  final DocumentReference ref;
  DateTime time = DateTime.now();
  List<dynamic> items;
  String email;
  double price;

  Order({
    this.ref,
    this.items,
    this.time,
    this.email,
  });

  String get id {
    return ref.id;
  }

  factory Order.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return Order.fromJson(snapshot.data(), snapshot.reference);
    }
    return null;
  }

  Order.fromJson(Map<String, dynamic> data, DocumentReference ref)
      : ref = ref,
        email = data['email'],
        time = data['time'],
        items = getItems(data['items']);

  Map<String, dynamic> toJson() => {
        'email': email,
        'time': time,
        'items': items.map((item) => item.toJson()).toList()
      };
}

// Need to set the type to List<dynamic> insite of Map<String, dynamic>
List<OrderItem> getItems(List<dynamic> items) {
  return items.map((item) => OrderItem.fromJson(item)).toList();
}

class OrderItem {
  /// Price at the date of the order
  double unitPrice;

  /// TODO: Change to product path as we keep the whole path
  String productId;
  int amount;

  OrderItem(this.productId, this.amount);
  OrderItem.fromJson(Map<String, dynamic> item)
      : productId = item['productId'],
        amount = item['amount'];

  Map<String, dynamic> toJson() => {'productId': productId, 'amount': amount};
}
