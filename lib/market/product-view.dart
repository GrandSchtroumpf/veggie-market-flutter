import 'package:flutter/material.dart';
import '../product/view.shell.dart';

class BuyerProductView extends StatelessWidget {
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
              Image.network(product.image, fit: BoxFit.fitWidth),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
              Text(
                '${product.price}€/${product.unit} - ${product.stock} in stock.',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
