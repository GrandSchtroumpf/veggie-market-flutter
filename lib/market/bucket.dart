import 'package:flutter/material.dart';
import '../product/model.dart';
import '../service.dart';

class MarketBucket extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final bucket = ServiceProvider.of(context).bucket;
    final product = ServiceProvider.of(context).product;
    return FutureBuilder<List<Product>>(
      future: product.getMany(bucket.items.keys.toList()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final List<Product> products = snapshot.data;
        return Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text('Bucket'),
          ),
          body: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) {
              Product product = products.elementAt(i);
              int amount = bucket.items[product.id];
              return ProductItem(product, amount);
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_shopping_cart),
            onPressed: () {
              final snackBar = SnackBar(
                content: Text('Order will be processed in next version 😉'),
                duration: Duration(seconds: 3),
              );
              _key.currentState.showSnackBar(snackBar);
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final int amount;
  ProductItem(this.product, this.amount);

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
      trailing: Text(
        amount.toString(),
      ),
    );
  }
}
