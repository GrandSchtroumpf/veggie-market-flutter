import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

/// Base function to run a query ///
Stream<List<T>> queryFrom<T>(
    Query ref, T Function(DocumentSnapshot) fromFirestore,
    [Query Function(CollectionReference) queryFn]) {
  if (queryFn == null) {
    queryFn = (ref) => ref;
  }

  fromSnapshot(QuerySnapshot snapshots) {
    return snapshots.docs
        .where((doc) => !doc.exists)
        .map(fromFirestore)
        .toList();
  }

  return queryFn(ref).snapshots().map(fromSnapshot).asBroadcastStream();
}

abstract class CollectionService<T> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  T Function(DocumentSnapshot) fromFirestore;
  Map<String, dynamic> Function(T) toFirestore;
  String name;

  CollectionReference get collection {
    return db.collection(name);
  }

  DocumentReference doc([String id]) {
    return collection.doc(id);
  }

  String createId() {
    return doc().id;
  }

  /// Query the collection ///
  Stream<List<T>> query([Query Function(CollectionReference) queryFn]) {
    return queryFrom(collection, fromFirestore, queryFn);
  }

  /// Query collection by name ///
  Stream<List<T>> queryGroup([Query Function(Query) queryFn]) {
    return queryFrom(db.collectionGroup(name), fromFirestore, queryFn);
  }

  /// Query one element in the collection ///
  Stream<T> queryOne(String id) {
    return doc(id).snapshots().map(fromFirestore).asBroadcastStream();
  }

  /// Query one element in the collection ///
  Stream<List<T>> queryMany(List<String> ids) {
    return CombineLatestStream.list(ids.map(queryOne)).asBroadcastStream();
  }

  /// Get one document by id ///
  Future<T> getOne(String id) {
    return doc(id).get().then(fromFirestore);
  }

  /// Get many documents ///
  Future<List<T>> getMany(List<String> ids) {
    final futures = ids.map((id) => getOne(id)).toList();
    return Future.wait(futures);
  }

  add(T doc) {
    final data = toFirestore(doc);
    return collection.add(data);
  }
}

abstract class SubAuthCollectionService<T> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final T Function(DocumentSnapshot) fromFirestore;
  final Map<String, dynamic> Function(T) toFirestore;
  final String parentName;
  final String name;

  SubAuthCollectionService({
    this.fromFirestore,
    this.toFirestore,
    this.parentName,
    this.name,
  });

  String createId() {
    return db.doc('').id;
  }

  CollectionReference collection(String parentId) {
    return db.collection(parentName).doc(parentId).collection(name);
  }

  DocumentReference doc(String parentId, [String id]) {
    return collection(parentId).doc(id);
  }

  /// Query the collection ///
  Stream<List<T>> query(String parentId,
      [Query Function(CollectionReference) queryFn]) {
    return queryFrom(collection(parentId), fromFirestore, queryFn);
  }

  /// Query collection by name ///
  Stream<List<T>> queryGroup([Query Function(Query) queryFn]) {
    return queryFrom(db.collectionGroup(name), fromFirestore, queryFn);
  }

  Stream<List<T>> queryOwn([Query Function(CollectionReference) queryFn]) {
    return auth.onAuthStateChanged
        .where((user) => user != null)
        .map((user) => user.uid)
        .switchMap((uid) => queryFrom(collection(uid), fromFirestore, queryFn));
  }

  /// Get one document based on a complete path ///
  Future<T> getOne(String path) {
    return db.doc(path).get().then(fromFirestore);
  }

  /// Get many documents with complete paths ///
  Future<List<T>> getMany(List<String> paths) {
    final futures = paths.map((path) => getOne(path)).toList();
    return Future.wait(futures);
  }

  String parentId(String path) {
    return path.split('/')[1];
  }
}
