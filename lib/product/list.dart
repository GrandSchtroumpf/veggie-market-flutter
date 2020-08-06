import 'package:flutter/material.dart';
import '../image/empty.dart';
import './model.dart';

class ProductList extends StatelessWidget {
  final Stream<List<Product>> query;
  final Widget whenEmpty;
  final Widget Function(BuildContext, Product) builder;

  ProductList({
    this.query,
    this.builder,
    this.whenEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return whenEmpty ?? Empty('There is not product here.');
        }
        List<Product> products = snapshot.data;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, i) => builder(context, products[i]),
        );
      },
    );
  }
}
