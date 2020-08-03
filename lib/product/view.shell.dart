import 'package:flutter/material.dart';
import '../service.dart';
import 'model.dart';

class ProductViewShell extends StatelessWidget {
  final Widget Function(BuildContext, Product) builder;
  ProductViewShell({this.builder});

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final service = ServiceProvider.of(context).product;
    return FutureBuilder<Product>(
      future: service.getValue(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('An error occured');
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return builder(context, snapshot.data);
      },
    );
  }
}
