import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../product/model.dart';
import '../order/model.dart';
import '../service.dart';
import './item.dart';

class MarketBucket extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final bucket = ServiceProvider.of(context).bucket;
    final productService = ServiceProvider.of(context).product;
    final orderService = ServiceProvider.of(context).order;
    return FutureBuilder<List<Product>>(
      future: productService.getMany(bucket.items.keys.toList()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        /// EMPTY ///
        if (snapshot.data.length == 0) {
          return Scaffold(
            appBar: AppBar(title: Text('Empty Bucket')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/img/empty.svg',
                    semanticsLabel: 'No product',
                    width: 300.0,
                  ),
                  Text(
                    'Your bucket is empty.',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
          );
        }

        /// BUCKET ///
        final List<Product> products = snapshot.data;
        return Scaffold(
          key: _key,
          appBar: AppBar(title: Text('Bucket')),
          body: ListView.builder(
            itemCount: products.length + 1,
            itemBuilder: (context, i) {
              if (i == products.length) {
                return TotalPrice(products);
              } else {
                return MarketItem(products[i]);
              }
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text('Send order'),
            icon: Icon(Icons.send),
            onPressed: () async {
              Order order = await bucket.createOrder(context);
              if (order != null) {
                await orderService.create(order);
                Navigator.pop(context);
                bucket.clear();
              } else {
                final snackBar = SnackBar(
                  content: Text('Could not send order.'),
                  duration: Duration(seconds: 3),
                );
                _key.currentState.showSnackBar(snackBar);
              }
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

class TotalPrice extends StatelessWidget {
  final List<Product> products;
  TotalPrice(this.products);
  @override
  Widget build(BuildContext context) {
    final bucket = ServiceProvider.of(context).bucket;
    return StreamBuilder<Map<String, int>>(
      initialData: bucket.items,
      stream: bucket.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('Total: 0€');
        }
        Map<String, int> items = snapshot.data;
        double total = products
            .map((product) => product.price * (items[product.id] ?? 0))
            .reduce((sum, price) => sum + price);
        return Center(
          child: Text(
            'Total: ${total.toString()}€',
            style: Theme.of(context).textTheme.headline6,
          ),
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
