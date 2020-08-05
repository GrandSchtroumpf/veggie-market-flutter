import 'package:flutter/material.dart';
import '../order/list.dart';
import '../service.dart';

class SellerOrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).order;
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: OrderList(
        query: service.queryOwn(),
        headerBuilder: (context, order) {
          return ListTile(
            title: Text('header'),
          );
        },
        itemBuilder: (contet, order) {
          return ListTile(
            title: Text('Item'),
          );
        },
      ),
    );
  }
}
