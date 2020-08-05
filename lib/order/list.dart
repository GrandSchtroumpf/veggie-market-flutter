import 'package:flutter/material.dart';
import './model.dart';

class OrderList extends StatefulWidget {
  final Stream<List<Order>> query;
  final Widget whenEmpty;
  final Widget whenLoading;
  final Widget Function(BuildContext, Order) headerBuilder;
  final Widget Function(BuildContext, OrderItem) itemBuilder;
  OrderList(
      {this.query,
      this.headerBuilder,
      this.itemBuilder,
      this.whenEmpty = const Text('Empty'),
      this.whenLoading = const Center(child: CircularProgressIndicator())});

  @override
  createState() => OrderListState(
        query: query,
        headerBuilder: headerBuilder,
        itemBuilder: itemBuilder,
        whenEmpty: whenEmpty,
        whenLoading: whenLoading,
      );
}

class OrderListState extends State<OrderList> {
  final Stream<List<Order>> query;
  final Widget whenEmpty;
  final Widget whenLoading;
  final Widget Function(BuildContext, Order) headerBuilder;
  final Widget Function(BuildContext, OrderItem) itemBuilder;
  final Map<String, bool> expanded = {};

  OrderListState({
    this.query,
    this.headerBuilder,
    this.itemBuilder,
    this.whenEmpty,
    this.whenLoading,
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
        if (snapshot.hasError) {
          return Text('An error occured ');
        }
        if (!snapshot.hasData) {
          return whenLoading;
        }
        if (snapshot.data.length == 0) {
          return whenEmpty;
        }
        List<Order> orders = snapshot.data;
        final panels = orders.map((order) => this.panel(context, order));
        return SingleChildScrollView(
          child: Container(
            child: ExpansionPanelList(
              expansionCallback: (i, _) => setState(() => toogle(orders[i])),
              children: panels.toList(),
            ),
          ),
        );
      },
    );
  }

  ExpansionPanel panel(BuildContext context, Order order) {
    return ExpansionPanel(
      headerBuilder: (context, _) => headerBuilder(context, order),
      body: ListView.builder(
        shrinkWrap: true, // Needed for the scroll to work as expected
        itemCount: order.items.length,
        itemBuilder: (contet, i) => itemBuilder(context, order.items[i]),
      ),
      isExpanded: isExpanded(order),
    );
  }
}
