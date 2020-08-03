import 'package:flutter/material.dart';
import '../service.dart';
import '../product/view.shell.dart';
import '../product/model.dart';
import '../product/form.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;

    return ProductViewShell(builder: (context, product) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit your Product'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                service.remove(product.id);
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: ProductForm(
          product: product,
          onSubmit: (Product product) async {
            if (product.file != null) {
              final task = service.upload(product.id, product.file);
              final snapshot = await task.onComplete;
              product.image = await snapshot.ref.getDownloadURL();
            }
            await service.update(product.id, product);
            Navigator.pop(context);
          },
        ),
      );
    });
  }
}
