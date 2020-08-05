import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  DocumentReference ref;
  String name;

  get id {
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
        name = data['name'];

  Map<String, dynamic> toJson() => {'name': name};
}
