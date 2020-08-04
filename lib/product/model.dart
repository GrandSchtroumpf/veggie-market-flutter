import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../service.dart';

const productImg =
    'https://images.unsplash.com/photo-1567779833503-606dc39a14fd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=300&q=60';

class Product {
  DocumentReference ref;
  String id;
  String name;
  String image;
  String unit;
  File file;
  double price;
  int stock;

  Product({
    this.ref,
    this.id,
    this.image,
    this.file,
    this.unit,
    this.name = '',
    this.price = 0.0,
    this.stock = 0,
  });
}

class ProductConverter extends Converter<Product> {
  @override
  Product fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    return Product(
      ref: snapshot.reference,
      id: snapshot.id,
      image: data['image'],
      name: data['name'] ?? '',
      price: data['price'] ?? 0.0,
      stock: data['stock'] ?? 0,
      unit: data['unit'],
    );
  }

  @override
  Map<String, dynamic> toFirestore(Product data) {
    return {
      'name': data.name,
      'image': data.image,
      'price': data.price,
      'stock': data.stock,
      'unit': data.unit,
    };
  }
}
