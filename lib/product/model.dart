import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../service-provider.dart';

const productImg =
    'https://images.unsplash.com/photo-1567779833503-606dc39a14fd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=300&q=60';

class Product {
  DocumentReference ref;
  String name;
  String image;
  String unit;
  File file;
  double price;
  int stock;

  Product({
    this.ref,
    this.image,
    this.file,
    this.unit,
    this.name,
    this.price,
    this.stock,
  });

  String get id {
    return ref.id;
  }

  String get path {
    return ref.path;
  }

  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return Product.fromJson(snapshot.data(), snapshot.reference);
    }
    return null;
  }

  Product.fromJson(Map<String, dynamic> data, DocumentReference ref)
      : ref = ref,
        image = data['image'],
        name = data['name'] ?? '',
        price = data['price'] ?? 0.0,
        stock = data['stock'] ?? 0,
        unit = data['unit'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'price': price,
        'stock': stock,
        'unit': unit,
      };
}
