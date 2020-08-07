import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import '../intl.dart';
import '../image/empty.dart';
import '../auth/shell.dart';
import '../product/model.dart';
import '../seller/model.dart';
import '../service-provider.dart';
import 'product-item.dart';

class BuyerProductList extends StatelessWidget {
  final intl = const Intl('buyer.product-list');

  @override
  Widget build(BuildContext context) {
    final sellerService = ServiceProvider.of(context).seller;
    final productService = ServiceProvider.of(context).product;
    final bucket = ServiceProvider.of(context).bucket;
    return AuthShell(
      title: intl.text('title'),
      body: StreamBuilder<List<Seller>>(
        stream: sellerService.query(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return intl.text('loading-seller');
          }
          if (snapshot.data.length == 0) {
            return Empty(intl.string(context, 'empty-seller'));
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
                return intl.text('loading-product');
              }
              final allProduct = snapshot.data;
              final all = [];
              sellers.asMap().forEach((i, seller) {
                if (allProduct[i].length > 0) {
                  all.add(seller);
                  allProduct[i].forEach((product) => all.add(product));
                }
              });
              if (all.length == sellers.length) {
                return Empty(intl.key('empty-product'));
              }
              return ListView.builder(
                itemCount: all.length,
                itemBuilder: (context, i) {
                  final item = all[i];
                  if (item is Seller) {
                    return sellerItem(item);
                  } else if (item is Product) {
                    return ProductItem(item, trailing: OrderItemCount(item));
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

  sellerItem(Seller seller) {
    return ListTile(
      title: Text(seller.name),
      trailing: CircleAvatar(
        maxRadius: 16.0,
        backgroundImage: seller.image != null
            ? NetworkImage(seller.image)
            : AssetImage('assets/img/seller.png'),
      ),
    );
  }
}
