import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

import '../_service.dart';
import './model.dart';

class ProductService extends SubAuthCollectionService<Product> {
  final StorageReference storage = FirebaseStorage().ref();
  ProductService()
      : super(
          fromFirestore: (snapshot) => Product.fromSnapshot(snapshot),
          toFirestore: (product) => product.toJson(),
          parentName: 'sellers',
          name: 'products',
        );

  Stream<List<List<Product>>> queryFromSellers(Iterable<String> ids,
      [Query Function(CollectionReference) queryFn]) {
    final queries = ids.map((id) => query(id, queryFn));
    return CombineLatestStream.list(queries).asBroadcastStream();
  }

  /// WRITE ///

  Future<CollectionReference> _ownCollection() {
    return auth.currentUser().then((user) => collection(user.uid));
  }

  Future<DocumentReference> create(Product doc) {
    final data = toFirestore(doc);
    return _ownCollection().then((collection) => collection.add(data));
  }

  /// Create a product based on an precreated id (used for the image)
  Future<void> setDoc(String id, Product doc) {
    final data = toFirestore(doc);
    return _ownCollection()
        .then((collection) => collection.doc(id))
        .then((document) => document.set(data));
  }

  Future<void> update(String id, Map<String, dynamic> data) {
    return _ownCollection()
        .then((collection) => collection.doc(id))
        .then((document) => document.update(data));
  }

  Future<void> updateDoc(Product doc) {
    final data = toFirestore(doc);
    return _ownCollection()
        .then((collection) => collection.doc(doc.id))
        .then((document) => document.update(data));
  }

  Future<void> remove(String id) {
    return _ownCollection().then((collection) => collection.doc(id).delete());
  }

  Future<StorageUploadTask> upload(String id, File file) async {
    FirebaseUser user = await auth.currentUser();
    String path = [parentName, user.uid, name, id].join('/');
    return storage.child(path).putFile(file);
  }
}
