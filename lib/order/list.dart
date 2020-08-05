import 'package:flutter/material.dart';
import './model.dart';

class OrderList extends StatefulWidget {
  final Stream<List<Order>> query;
  final Widget whenEmpty;
  final Widget Function(BuildContext, Order) headerBuilder;
  final Widget Function(BuildContext, Order) itemBuilder;
  OrderList({
    this.query,
    this.headerBuilder,
    this.itemBuilder,
    this.whenEmpty = const Text('Empty'),
  });

  @override
  createState() => OrderListState(
        query: query,
        headerBuilder: headerBuilder,
        itemBuilder: itemBuilder,
        whenEmpty: whenEmpty,
      );
}

class OrderListState extends State<OrderList> {
  final Stream<List<Order>> query;
  final Widget whenEmpty;
  final Widget Function(BuildContext, Order) headerBuilder;
  final Widget Function(BuildContext, Order) itemBuilder;
  Map<String, bool> expanded;

  OrderListState({
    this.query,
    this.headerBuilder,
    this.itemBuilder,
    this.whenEmpty = const Text('Empty'),
  });

  isExpanded(Order order) {
    return expanded[order.id] ?? false;
  }

  toogle(Order order) {
    setState(() => expanded[order.id] = !isExpanded(order));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return whenEmpty;
        }
        List<Order> orders = snapshot.data;
        final panels = orders.map((order) => this.panel(context, order));
        return ExpansionPanelList(
          //expansionCallback: () {},
          children: panels.toList(),
        );
      },
    );
  }

  ExpansionPanel panel(BuildContext context, Order order) {
    return ExpansionPanel(
      headerBuilder: (context, _) => headerBuilder(context, order),
      body: itemBuilder(context, order),
      isExpanded: isExpanded(order),
    );
  }
}
