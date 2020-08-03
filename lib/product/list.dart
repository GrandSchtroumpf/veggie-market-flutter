import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../service.dart';
import './model.dart';

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
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
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
                  RaisedButton(
                    child: Text('Add your first Product'),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => Navigator.pushNamed(context, '/create'),
                  )
                ],
              ),
            );
          }
          final docs = snapshot.data;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) => ProductItem(docs[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/create'),
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
        Navigator.pushNamed(context, '/edit', arguments: product.id);
      },
    );
  }
}
