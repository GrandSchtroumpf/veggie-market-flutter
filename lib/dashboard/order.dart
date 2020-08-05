import 'package:flutter/material.dart';
import '../order/model.dart';
import '../service.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).order;
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: StreamBuilder<List<Order>>(
        stream: service.valueChanges((ref) => ref),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('No order yet');
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              Order order = snapshot.data[i];
              return ListTile(
                title: Text(order.email),
              );
            },
          );
        },
      ),
    );
  }
}
