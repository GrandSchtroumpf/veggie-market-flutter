import 'package:flutter/material.dart';
import './model.dart';

class SellerList extends StatelessWidget {
  final Stream<List<Seller>> query;
  final Widget whenEmpty;
  final Widget Function(BuildContext, Seller) builder;

  SellerList({
    this.query,
    this.builder,
    this.whenEmpty = const Text('Empty'),
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return whenEmpty;
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
