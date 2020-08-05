import 'package:flutter/material.dart';
import './model.dart';

class ProductList extends StatelessWidget {
  final Stream<List<Product>> query;
  final Widget whenEmpty;
  final Widget Function(BuildContext, Product) builder;

  ProductList({
    this.query,
    this.builder,
    this.whenEmpty = const Text('Empty'),
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return whenEmpty;
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
