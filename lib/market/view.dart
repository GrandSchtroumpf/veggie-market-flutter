import 'package:flutter/material.dart';
import '../product/view.shell.dart';

class MarketView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductViewShell(
      builder: (context, product) {
        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
          ),
          body: Image.network(product.image),
        );
      },
    );
  }
}
