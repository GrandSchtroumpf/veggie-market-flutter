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
    setAmount(product, (items[product.path] ?? 0) + 1);
  }

  remove(Product product) {
    if (items[product.path] != null && items[product.path] > 0) {
      setAmount(product, items[product.path] - 1);
    }
  }

  void setAmount(Product product, int amount) {
    if (product.stock - amount >= 0) {
      items[product.path] = amount;
      if (amount == 0) {
        items.remove(product.path);
      }
      _ctrl.add(items);
    }
  }

  clear() {
    items.clear();
    _ctrl.add(items);
  }

  getEmail(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      return user.email;
    } else {
      return showDialog(
        context: context,
        builder: (context) => OrderPage(),
      );
    }
  }
}
