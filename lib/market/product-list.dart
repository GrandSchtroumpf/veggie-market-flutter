import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:veggie_market/auth/shell.dart';
import 'package:badges/badges.dart';
// import 'package:veggie_market/dashboard/list.dart';
import 'package:veggie_market/seller/list.dart';
import '../service.dart';
import '../product/list.dart';
import './item.dart';

class BuyerProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sellerService = ServiceProvider.of(context).seller;
    final productService = ServiceProvider.of(context).product;
    final bucket = ServiceProvider.of(context).bucket;
    return AuthShell(
      title: 'Market',
      body: SellerList(
        query: sellerService.query(),
        builder: (context, seller) {
          final productQuery = productService.query(
            seller.id,
            (ref) => ref.where('stock', isGreaterThan: 0),
          );
          return Column(
            children: [
              ListTile(title: Text('Seller')),
              ProductList(
                query: productQuery,
                builder: (context, product) => MarketItem(product),
                whenEmpty: Center(
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
                ),
              ),
            ],
          );
        },
      ),
      // body: StreamBuilder<List<Product>>(
      //   stream: service.valueChanges((ref) {
      //     return ref.where('stock', isGreaterThan: 0);
      //   }),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('An error occured ' + snapshot.error.toString());
      //     }

      //     /// LOADING ///
      //     if (!snapshot.hasData) {
      //       return Center(child: CircularProgressIndicator());
      //     }

      //     /// EMPTY ///
      //     if (snapshot.data.length == 0) {
      //       return Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             SvgPicture.asset(
      //               'assets/img/empty.svg',
      //               semanticsLabel: 'No product',
      //               width: 300.0,
      //             ),
      //             Text(
      //               'There is nothing here yet.',
      //               style: Theme.of(context).textTheme.subtitle1,
      //             ),
      //           ],
      //         ),
      //       );
      //     }

      //     /// LIST ///
      //     final docs = snapshot.data;
      //     return ListView.builder(
      //       itemCount: docs.length,
      //       itemBuilder: (context, i) => MarketItem(docs[i]),
      //     );
      //   },
      // ),
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
}
