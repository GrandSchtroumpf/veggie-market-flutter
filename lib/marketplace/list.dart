import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../service.dart';
import '../product/model.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: StreamBuilder<List<Product>>(
        stream: service.valueChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('An error occured ' + snapshot.error);
          }

          /// LOADING ///
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          /// EMPTY ///
          if (snapshot.data.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/img/empty.svg',
                    semanticsLabel: 'No product',
                    width: 300.0,
                  ),
                  Text(
                    'There is nothing here yet.',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            );
          }

          /// LIST ///
          final docs = snapshot.data;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) => ProductItem(docs[i]),
          );
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.image ?? productImg),
      ),
      title: Text(product.name),
      subtitle: Text(
        '${product.price}€/${product.unit} - ${product.stock} in stock.',
      ),
      onTap: () {
        Navigator.pushNamed(context, '/view', arguments: product.id);
      },
    );
  }
}
