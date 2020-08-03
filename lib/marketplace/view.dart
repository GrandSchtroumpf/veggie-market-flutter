import 'package:flutter/material.dart';
import '../service.dart';
import '../product/model.dart';

class ProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final service = ServiceProvider.of(context).product;
    return FutureBuilder(
      future: service.getValue(id),
      builder: (context, snapshot) {
        Product product = snapshot.data;
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
