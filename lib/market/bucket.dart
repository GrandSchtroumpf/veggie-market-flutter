import 'package:flutter/material.dart';
import 'package:veggie_market/image/empty.dart';
import '../intl.dart';
import '../product/model.dart';
import '../service-provider.dart';
import 'product-item.dart';

class BuyerBucket extends StatelessWidget {
  final intl = const Intl('buyer.bucket');
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final services = ServiceProvider.of(context);
    final bucket = services.bucket;
    final productService = services.product;
    final orderService = services.order;
    return FutureBuilder<List<Product>>(
      future: productService.getMany(bucket.items.keys.toList()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.length == 0) {
          return Scaffold(
              appBar: AppBar(title: intl.text('title')),
              body: Empty(intl.key('empty')));
        }

        /// BUCKET ///
        final List<Product> products = snapshot.data;
        return Scaffold(
          key: _key,
          appBar: AppBar(title: intl.text('title')),
          body: ListView.builder(
            itemCount: products.length + 1,
            itemBuilder: (context, i) {
              if (i == products.length) {
                return TotalPrice(products);
              } else {
                return ProductItem(
                  products[i],
                  trailing: OrderItemCount(products[i]),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: intl.text('order'),
            icon: Icon(Icons.send),
            onPressed: () async {
              String email = await bucket.getEmail(context);
              if (email == null) {
                return;
              }
              try {
                await orderService.createFromBucket(email, bucket.items);
                await showSnackBar('order-success');
                Navigator.pop(context);
                bucket.clear();
              } catch (err) {
                await showSnackBar('order-failed');
              }
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Future<SnackBarClosedReason> showSnackBar(String key) {
    final snackBar = SnackBar(
      content: intl.text(key),
      duration: Duration(seconds: 3),
    );
    return _key.currentState.showSnackBar(snackBar).closed;
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
            .map((product) => product.price * (items[product.path] ?? 0))
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
