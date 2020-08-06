import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veggie_market/service.dart';

class Seller implements DocumentModel {
  DocumentReference ref;
  String name;
  File file;
  String description;
  String image;

  String get id {
    return ref.id;
  }

  factory Seller.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return Seller.fromJson(snapshot.data(), snapshot.reference);
    }
    return null;
  }

  Seller.fromJson(Map<String, dynamic> data, DocumentReference ref)
      : ref = ref,
        name = data['name'],
        description = data['description'],
        image = data['image'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'image': image,
      };
}
