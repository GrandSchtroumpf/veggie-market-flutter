import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../market/order.dart';
import '../product/model.dart';
import './model.dart';

class Bucket {
  final StreamController<Map<String, int>> _ctrl = StreamController.broadcast();
  final Map<String, int> items = {};

  Stream<Map<String, int>> get stream {
    return _ctrl.stream;
  }

  Stream<int> queryItem(String productId) {
    return stream.map((items) => items[productId] ?? 0).distinct();
  }

  add(Product product) {
    setAmount(product, (items[product.id] ?? 0) + 1);
  }

  remove(Product product) {
    if (items[product.id] != null && items[product.id] > 0) {
      setAmount(product, items[product.id] - 1);
    }
  }

  void setAmount(Product product, int amount) {
    if (product.stock - amount >= 0) {
      items[product.id] = amount;
      if (amount == 0) {
        items.remove(product.id);
      }
      _ctrl.add(items);
    }
  }

  clear() {
    items.clear();
    _ctrl.add(items);
  }

  createOrder(BuildContext context) async {
    String email;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      email = user.email;
    } else {
      email = await showDialog(
        context: context,
        builder: (context) => OrderPage(),
      );
    }
    if (email == null) {
      return null;
    }
    final List<OrderItem> orderItems = [];
    items.forEach((key, value) {
      if (value != 0) {
        orderItems.add(OrderItem(key, value));
      }
    });
    return Order(email: email, items: orderItems);
  }
}
