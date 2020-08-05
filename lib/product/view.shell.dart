import 'package:flutter/material.dart';
import 'model.dart';

// TODO: Remove this as we pass the products with the arguments

class ProductViewShell extends StatelessWidget {
  final Widget Function(BuildContext, Product) builder;
  ProductViewShell({this.builder});

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;
    return builder(context, product);
  }
}
