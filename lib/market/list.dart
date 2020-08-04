import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:veggie_market/auth/shell.dart';
import 'package:badges/badges.dart';
import '../service.dart';
import '../product/model.dart';

class MarketList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;
    final bucket = ServiceProvider.of(context).bucket;
    return AuthShell(
      title: 'Market',
      body: StreamBuilder<List<Product>>(
        stream: service.valueChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('An error occured ' + snapshot.error.toString());
          }

          /// LOADING ///
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          /// EMPTY ///
          if (snapshot.data.length == 0) {
            return Center(
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
                    'There is nothing here yet.',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            );
          }

          /// LIST ///
          final docs = snapshot.data;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) => ProductItem(docs[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/m/bucket'),
        child: Badge(
          badgeContent: StreamBuilder<Map<String, int>>(
            initialData: {},
            stream: bucket.stream,
            builder: (ctx, snapshot) => Text(snapshot.data.length.toString()),
          ),
          child: Icon(Icons.shopping_basket),
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;
    final bucket = ServiceProvider.of(context).bucket;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.image ?? productImg),
      ),
      title: Text(product.name),
      subtitle: Text(
        '${product.price}€/${product.unit} - ${product.stock} in stock.',
      ),
      trailing: IconButton(
        onPressed: () {
          product.stock = product.stock - 1;
          service.update(product.id, product);
        },
        icon: IconButton(
          onPressed: () => bucket.add(product),
          icon: Icon(Icons.add),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/m/view', arguments: product.id);
      },
    );
  }
}