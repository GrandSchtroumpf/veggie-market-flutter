import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

/// Base function to run a query ///
Stream<List<T>> queryFrom<T>(
    Query ref, T Function(DocumentSnapshot) fromFirestore,
    [Query Function(Query) queryFn]) {
  if (queryFn == null) {
    queryFn = (ref) => ref;
  }

  List<T> fromSnapshot(QuerySnapshot snapshots) {
    return snapshots.docs
        .where((doc) => doc.exists)
        .map(fromFirestore)
        .toList();
  }

  return queryFn(ref).snapshots().map(fromSnapshot).asBroadcastStream();
}

abstract class DocumentModel {
  DocumentReference ref;
  String get id;
}

abstract class CollectionService<T extends DocumentModel> {
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
  Stream<List<T>> query([Query Function(Query) queryFn]) {
    Query ref = collection;
    return queryFrom(ref, fromFirestore, queryFn);
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

  Future<void> updateDoc(T document) {
    final data = toFirestore(document);
    return doc(document.id).update(data);
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
    return db.collection('EMPTY').doc().id;
  }

  CollectionReference collection(String parentId) {
    return db.collection(parentName).doc(parentId).collection(name);
  }

  DocumentReference doc(String parentId, [String id]) {
    return collection(parentId).doc(id);
  }

  /// Query the collection ///
  Stream<List<T>> query(String parentId, [Query Function(Query) queryFn]) {
    Query ref = collection(parentId);
    return queryFrom(ref, fromFirestore, queryFn);
  }

  /// Query collection by name ///
  Stream<List<T>> queryGroup([Query Function(Query) queryFn]) {
    Query ref = db.collectionGroup(name);
    return queryFrom(ref, fromFirestore, queryFn);
  }

  Stream<List<T>> queryOwn([Query Function(Query) queryFn]) {
    Query Function(FirebaseUser) query = (user) => collection(user.uid);
    return auth.onAuthStateChanged
        .where((user) => user != null)
        .switchMap((user) => queryFrom(query(user), fromFirestore, queryFn));
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
