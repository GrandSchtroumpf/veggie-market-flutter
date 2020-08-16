import 'package:flutter/material.dart';
import '../intl.dart';
import '../product/view.shell.dart';

class BuyerProductView extends StatelessWidget {
  final intl = const Intl('buyer.product-view');

  @override
  Widget build(BuildContext context) {
    return ProductViewShell(
      builder: (context, product) {
        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'products.${product.id}.image',
                child: Image.network(product.image, fit: BoxFit.fitWidth),
              ),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
