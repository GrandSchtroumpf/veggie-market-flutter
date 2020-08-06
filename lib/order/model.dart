import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final DocumentReference ref;
  Timestamp time = Timestamp.now();
  List<OrderItem> items;
  String email;

  Order({
    this.ref,
    this.items,
    this.time,
    this.email,
  });

  String get id {
    return ref.id;
  }

  double get totalPrice {
    return items
        .map((item) => item.price)
        .reduce((total, price) => total + price);
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
  double productPrice;
  String productPath;
  int amount;

  double get price {
    return productPrice * amount;
  }

  OrderItem(this.productPath, this.amount, this.productPrice);
  OrderItem.fromJson(Map<String, dynamic> item)
      : productPath = item['productPath'],
        amount = item['amount'],
        productPrice = item['productPrice'];

  Map<String, dynamic> toJson() => {
        'productPath': productPath,
        'amount': amount,
        'productPrice': productPrice,
      };
}
