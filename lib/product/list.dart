import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../service.dart';
import './model.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;
    return StreamBuilder<List<Product>>(
      initialData: [],
      stream: service.valueChanges(),
      builder: (context, snapshot) {
        Widget body;
        Widget actionButton = SizedBox.shrink(); // Empty
        if (snapshot.hasError) {
          body = Text('An error occured ' + snapshot.error);
        }
        if (!snapshot.hasData) {
          body = Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data;
        if (snapshot.data.length == 0) {
          body = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/img/empty.svg',
                  semanticsLabel: 'No product',
                  width: 300.0,
                ),
                RaisedButton(
                  child: Text('Add your first Product'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => Navigator.pushNamed(context, '/create'),
                )
              ],
            ),
          );
        } else {
          body = ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) => ProductItem(docs[i]),
          );
          actionButton = FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/create'),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('Home')),
          body: body,
          floatingActionButton: actionButton,
        );
      },
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
        Navigator.pushNamed(context, '/edit', arguments: product.id);
      },
    );
  }
}
