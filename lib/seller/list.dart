import 'package:flutter/material.dart';
import 'package:veggie_market/image/empty.dart';
import './model.dart';

class SellerList extends StatelessWidget {
  final Stream<List<Seller>> query;
  final Widget whenEmpty;
  final Widget Function(BuildContext, Seller) builder;

  SellerList({
    this.query,
    this.builder,
    this.whenEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return whenEmpty ?? Empty('We could not find any seller.');
        }
        List<Seller> sellers = snapshot.data;
        return ListView.builder(
          itemCount: sellers.length,
          itemBuilder: (context, i) => builder(context, sellers[i]),
        );
      },
    );
  }
}
