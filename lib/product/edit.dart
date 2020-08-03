import 'package:flutter/material.dart';
import '../service.dart';
import './model.dart';
import './form.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final service = ServiceProvider.of(context).product;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit your Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              service.remove(id);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: FutureBuilder<Product>(
        future: service.getValue(id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('An error occured');
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ProductForm(
            product: snapshot.data,
            onSubmit: (Product product) async {
              if (product.file != null) {
                final task = service.upload(product.id, product.file);
                final snapshot = await task.onComplete;
                product.image = await snapshot.ref.getDownloadURL();
              }
              service.update(id, product);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
