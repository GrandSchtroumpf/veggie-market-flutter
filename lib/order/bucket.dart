import 'dart:async';

import '../product/model.dart';
import './model.dart';

class Bucket {
  final StreamController<Map<String, int>> _ctrl = StreamController.broadcast();
  final Map<String, int> items = {};

  Stream<Map<String, int>> get stream {
    return _ctrl.stream;
  }

  add(Product product) {
    if (product.stock != 0) {
      product.stock--;
      if (items[product.id] == null) {
        items[product.id] = 0;
      } else {
        items[product.id]++;
      }
      _ctrl.add(items);
    }
  }

  remove(Product product) {
    if (items[product.id] > 0) {
      items[product.id]--;
      product.stock++;
      _ctrl.add(items);
    }
  }

  createOrder(String name) {
    final List<OrderItem> orderItems = [];
    items.forEach((key, value) {
      if (value != 0) {
        orderItems.add(OrderItem(key, value));
      }
    });
    return Order(name, orderItems);
  }
}
