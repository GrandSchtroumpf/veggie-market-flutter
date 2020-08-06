import 'package:flutter/material.dart';
import '../auth/shell.dart';
import '../order/list.dart';
import '../product/model.dart';
import '../service-provider.dart';

class BuyerOrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productService = ServiceProvider.of(context).product;
    final orderService = ServiceProvider.of(context).order;
    return AuthShell(
      title: 'Orders',
      body: OrderList(
        query: orderService.queryByEmail(),
        headerBuilder: (context, order) {
          return ListTile(
            title: Text('Total: ${order.totalPrice}€'),
            subtitle: Text(order.email),
          );
        },
        itemBuilder: (context, item) {
          return FutureBuilder<Product>(
            future: productService.getOne(item.productPath),
            builder: (context, snaphot) {
              if (!snaphot.hasData) {
                return Text('Loading');
              }
              final product = snaphot.data;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(product.image),
                ),
                title: Text(product.name),
                subtitle: Text('Total: ${item.price}€'),
                trailing: Text('${item.amount}${product.unit}'),
              );
            },
          );
        },
      ),
    );
  }
}
