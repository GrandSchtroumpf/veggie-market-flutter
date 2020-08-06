import 'package:firebase_auth/firebase_auth.dart';

import 'package:rxdart/rxdart.dart';
import '../service.dart';
import './model.dart';

class SellerService extends CollectionService<Seller> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fromFirestore = (snapshot) => Seller.fromSnapshot(snapshot);
  final toFirestore = (seller) => seller.toJson();
  final name = 'sellers';

  Stream<bool> isSellerChange(String uid) {
    return doc(uid).snapshots().map((snapshot) => snapshot.exists);
  }

  queryCurrent() {
    return _auth.onAuthStateChanged.switchMap((user) => queryOne(user.uid));
  }

  getCurrent() {
    return _auth.currentUser().then((user) => getOne(user.uid));
  }

  becomeSeller() {
    _auth
        .currentUser()
        .then((user) => doc(user.uid).set({'name': 'Schtroumpf'}));
  }
}
