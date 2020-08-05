import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart';
import '../auth/shell.dart';
import '../product/model.dart';
import '../seller/model.dart';
import '../service.dart';
import './item.dart';

class BuyerProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sellerService = ServiceProvider.of(context).seller;
    final productService = ServiceProvider.of(context).product;
    final bucket = ServiceProvider.of(context).bucket;
    return AuthShell(
      title: 'Market',
      body: StreamBuilder<List<Seller>>(
        stream: sellerService.query(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading Sellers');
          }
          if (snapshot.data.length == 0) {
            return empty(context);
          }
          final sellers = snapshot.data;
          final sellerIds = sellers.map((seller) => seller.id);
          final stream = productService.queryFromSellers(
            sellerIds,
            (ref) => ref.where('stock', isGreaterThan: 0),
          );
          // We want to mix sellers & product so we need a dynamic
          return StreamBuilder<List<List<dynamic>>>(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading Products');
              }
              final allProduct = snapshot.data;
              final all = [];
              sellers.asMap().forEach((i, seller) {
                all.add(seller);
                allProduct[i].forEach((product) => all.add(product));
              });
              if (all.length == sellers.length) {
                return empty(context);
              }
              return ListView.builder(
                itemCount: all.length,
                itemBuilder: (context, i) {
                  final item = all[i];
                  if (item is Seller) {
                    return ListTile(title: Text(item.name));
                  } else if (item is Product) {
                    return MarketItem(item);
                  } else {
                    return SizedBox.shrink(); // Should not happen
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/m/bucket'),
        child: Badge(
          badgeContent: StreamBuilder<Map<String, int>>(
            initialData: bucket.items,
            stream: bucket.stream,
            builder: (ctx, snapshot) => Text(snapshot.data.length.toString()),
          ),
          child: Icon(Icons.shopping_basket),
        ),
      ),
    );
  }

  empty(BuildContext context) {
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
}