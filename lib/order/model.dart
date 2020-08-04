class Order {
  final DateTime time = DateTime.now();
  final List<OrderItem> items;
  final String buyer;
  Order(this.buyer, this.items);
}

class OrderItem {
  String productId;
  int amount;

  OrderItem(this.productId, this.amount);
}
