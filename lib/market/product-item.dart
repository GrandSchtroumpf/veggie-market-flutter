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
          child: SizedBox(
            width: 40.0,
            child: Hero(
              tag: 'products.${product.id}.image',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/m/view',
                        arguments: product,
                      );
                    },
                    child: Image.network(product.image ?? productImg),
                  ),
                ),
              ),
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
