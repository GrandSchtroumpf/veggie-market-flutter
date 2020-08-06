import 'package:rxdart/rxdart.dart';
import '../_service.dart';
import '../product/model.dart';
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
      List<Future> futures = [];
      // For each product
      bucket.forEach((path, amount) {
        if (amount == 0) {
          return tx;
        }
        // Remove amount from current product
        final ref = db.doc(path);
        final update = tx
            .get(ref)
            .then((snapshot) => Product.fromSnapshot(snapshot))
            .then((product) {
          tx.update(ref, {'stock': product.stock - amount});
          // Sort by Seller
          final sellerId = path.split('/')[1];
          final item = OrderItem(path, amount, product.price);
          if (itemsBySellers[sellerId] == null) {
            itemsBySellers[sellerId] = [item];
          } else {
            itemsBySellers[sellerId].add(item);
          }
        });
        futures.add(update);
      });
      await Future.wait(futures);

      // Create Orders
      itemsBySellers.forEach((sellerId, items) {
        final order = Order(email: email, items: items);
        final ref = collection(sellerId).doc();
        tx.set(ref, order.toJson());
      });
    });
  }
}
