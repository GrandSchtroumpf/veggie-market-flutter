import 'package:flutter/material.dart';
import '../service.dart';
import './model.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;
    return StreamBuilder<List<Product>>(
      stream: service.valueChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('An error occured ' + snapshot.error);
        }
        if (!snapshot.hasData) {
          return Text('Loading');
        }
        final docs = snapshot.data;
        if (snapshot.data.length == 0) {
          return Text('Empty');
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) => ProductItem(docs[i]),
        );
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.image ?? productImg),
      ),
      title: Text(product.name),
      subtitle: Text(
        '${product.price}€/${product.unit} - ${product.stock} in stock.',
      ),
      onTap: () {
        Navigator.pushNamed(context, '/edit', arguments: product.id);
      },
    );
  }
}
