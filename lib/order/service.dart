import 'package:rxdart/rxdart.dart';
import '../_service.dart';
import './model.dart';

class OrderService extends SubAuthCollectionService<Order> {
  OrderService()
      : super(
          fromFirestore: (snapshot) => Order.fromSnapshot(snapshot),
          toFirestore: (order) => order.toJson(),
          parentName: 'sellers',
          name: 'orders',
        );

  Stream<List<Order>> queryByEmail(String email) {
    return auth.onAuthStateChanged
        .where((user) => user != null)
        .map((user) => user.email)
        .switchMap((email) =>
            queryGroup((ref) => ref.where('email', isEqualTo: email)));
  }

  Future createFromBucket(String email, Map<String, int> bucket) {
    return db.runTransaction((tx) async {
      Map<String, List<OrderItem>> itemsBySellers = {};
      // For each product
      bucket.forEach((path, amount) async {
        if (amount == 0) {
          return;
        }
        // Sort by Seller
        final sellerId = path.split('/')[1];
        if (itemsBySellers[sellerId] != null) {
          itemsBySellers[sellerId] = [OrderItem(path, amount)];
        } else {
          itemsBySellers[sellerId].add(OrderItem(path, amount));
        }
        // Remove amount from current product
        final ref = db.doc(path);
        final snapshot = await tx.get(ref);
        int stock = snapshot.data()['stock'];
        tx.update(ref, {'stock': stock - amount});
      });

      // Create Orders
      itemsBySellers.forEach((sellerId, items) {
        final order = Order(email: email, items: items);
        final ref = collection(sellerId).doc();
        tx.set(ref, order.toJson());
      });
    });
  }
}