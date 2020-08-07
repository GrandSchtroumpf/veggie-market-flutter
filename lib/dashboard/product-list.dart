import 'package:flutter/material.dart';
import '../intl.dart';
import '../image/empty.dart';
import '../service-provider.dart';
import '../product/model.dart';
import '../auth/shell.dart';

class SellerProductList extends StatelessWidget {
  final intl = const Intl('seller.product-list');
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;
    return AuthShell(
      title: intl.text('title'),
      body: StreamBuilder<List<Product>>(
        stream: service.queryOwn(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('An error occured ' + snapshot.error.toString());
          }

          /// LOADING ///
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          /// EMPTY ///
          if (snapshot.data.length == 0) {
            return Empty(intl.key('empty'));
          }

          /// LIST ///
          final docs = snapshot.data;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) => ProductItem(docs[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/d/create'),
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
      trailing: Icon(Icons.edit),
      onTap: () {
        Navigator.pushNamed(context, '/d/edit', arguments: product);
      },
    );
  }
}
