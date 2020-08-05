import 'package:flutter/material.dart';
import 'package:veggie_market/auth/shell.dart';
import '../order/list.dart';
import '../service.dart';

class SellerOrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).order;
    return AuthShell(
      title: 'Orders',
      body: OrderList(
        query: service.queryOwn(),
        headerBuilder: (context, order) {
          return ListTile(
            title: Text('Work in Progress'),
            subtitle: Text(order.email),
          );
        },
        itemBuilder: (contet, item) {
          return ListTile(
            title: Text('Item ordered'),
            subtitle: Text(item.productId),
          );
        },
      ),
    );
  }
}
