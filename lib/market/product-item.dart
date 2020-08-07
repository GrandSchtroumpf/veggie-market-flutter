import 'package:flutter/material.dart';
import '../intl.dart';
import '../product/model.dart';
import '../service-provider.dart';

class ProductItem extends StatelessWidget {
  final intl = Intl('buyer.product-item');
  final Product product;
  final Widget trailing;
  ProductItem(this.product, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/m/view', arguments: product);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(product.image ?? productImg),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                '${product.price}€/${product.unit} - ${product.stock} ${intl.string(context, 'stock')}.',
              )
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}

class OrderItemCount extends StatelessWidget {
  final Product product;

  OrderItemCount(this.product);
  @override
  Widget build(BuildContext context) {
    final bucket = ServiceProvider.of(context).bucket;

    return StreamBuilder<int>(
      initialData: bucket.items[product.path] ?? 0,
      stream: bucket.queryItem(product.path),
      builder: (context, snapshot) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => bucket.remove(product),
              icon: Icon(Icons.remove),
            ),
            Text(snapshot.data.toString()),
            IconButton(
              onPressed: () => bucket.add(product),
              icon: Icon(Icons.add),
            )
          ],
        );
      },
    );
  }
}
