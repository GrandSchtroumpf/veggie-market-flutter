import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../service.dart';

class Order {
  final String id;
  final DocumentReference ref;
  DateTime time = DateTime.now();
  List<OrderItem> items;
  String email;

  Order({
    this.id,
    this.ref,
    this.items,
    this.time,
    this.email,
  });
}

class OrderItem {
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
    final data = snapshot.data();
    return Order(
      ref: snapshot.reference,
      id: snapshot.id,
      items: jsonDecode(data['items']), // TODO: make it work normally
      time: data['time'],
      email: data['email'],
    );
  }

  @override
  Map<String, dynamic> toFirestore(Order data) {
    return {
      'email': data.email,
      'time': data.time,
      'items': jsonEncode(data.items),
    };
  }
}
