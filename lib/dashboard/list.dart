import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../service.dart';
import '../product/model.dart';
import '../auth/shell.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;
    return AuthShell(
      title: 'Dashboard',
      body: StreamBuilder<List<Product>>(
        stream: service.valueChanges((ref) => ref),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'You list is empty',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SvgPicture.asset(
                    'assets/img/empty.svg',
                    semanticsLabel: 'No product',
                    width: 300.0,
                  ),
                  Text(
                    'Click on the + button below to create a product.',
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
        Navigator.pushNamed(context, '/d/edit', arguments: product.id);
      },
    );
  }
}
