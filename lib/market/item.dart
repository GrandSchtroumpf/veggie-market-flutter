import 'package:flutter/material.dart';
import '../product/model.dart';
import '../service.dart';

class MarketItem extends StatelessWidget {
  final Product product;
  MarketItem(this.product);

  @override
  Widget build(BuildContext context) {
    final bucket = ServiceProvider.of(context).bucket;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(product.image ?? productImg),
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
                '${product.price}€/${product.unit} - ${product.stock} in stock.',
              )
            ],
          ),
        ),
        StreamBuilder<int>(
          initialData: bucket.items[product.id] ?? 0,
          stream: bucket.queryItem(product.id),
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
        ),
      ],
    );
  }
}
