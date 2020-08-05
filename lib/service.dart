import 'dart:io';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import './order/model.dart';
import './order/bucket.dart';
import './product/model.dart';

abstract class Converter<T> {
  T fromFirestore(DocumentSnapshot snapshot);
  dynamic toFirestore(T data);
  // Map<String, dynamic> toFirestore(T data);
}

/// A base service class
class Service<T> {
  StorageReference storage;
  CollectionReference collection;
  Converter<T> converter;

  Service(String name, this.converter) {
    collection = FirebaseFirestore.instance.collection(name);
    storage = FirebaseStorage().ref().child(name);
  }

  DocumentReference doc(String id) {
    return this.collection.doc(id);
  }

  Future<DocumentReference> create(T doc) {
    final data = converter.toFirestore(doc);
    return this.collection.add(data);
  }

  Future<void> update(String id, T doc) {
    final data = converter.toFirestore(doc);
    return this.doc(id).update(data);
  }

  Future<void> remove(String id) {
    return this.doc(id).delete();
  }

  Future<T> getValue(String id) async {
    final snapshot = await this.doc(id).get();
    return snapshot.exists ? converter.fromFirestore(snapshot) : null;
  }

  Future<List<T>> getMany(List<String> ids) async {
    return Future.wait(ids.map((id) => getValue(id)));
  }

  Stream<List<T>> valueChanges(Query Function(CollectionReference) queryFn) {
    final stream = queryFn(collection).snapshots();
    return stream.map((event) {
      final docs = event.docs;
      docs.removeWhere((s) => !s.exists);
      return docs.map((s) => converter.fromFirestore(s)).toList();
    });
  }

  /// TODO: Change path to be "users/:userId/products/filename"
  StorageUploadTask upload(String id, File file) {
    final String filename = basename(file.path);
    return storage.child(id).child(filename).putFile(file);
  }
}

/// Provide the list of service for the app
/// Create the service only on demand
class ServiceProvider extends InheritedWidget {
  final product = Service<Product>('products', ProductConverter());
  final order = Service<Order>('orders', OrderConverter());
  final bucket = Bucket();
  final Map<String, Service> services = {};

  ServiceProvider({Key key, @required Widget child})
      : super(key: key, child: child);

  static ServiceProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ServiceProvider>();
  }

  @override
  bool updateShouldNotify(ServiceProvider old) => true;

  Service<T> get<T>(String name, Converter<T> converter) {
    if (!services.containsKey(name)) {
      services[name] = Service<T>(name, converter);
    }
    return services[name];
  }
}
