import 'dart:async';

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
