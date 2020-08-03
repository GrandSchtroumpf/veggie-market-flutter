import 'package:flutter/material.dart';
import '../service.dart';
import '../product/model.dart';
import '../product/form.dart';

class CreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;
    return Scaffold(
      appBar: AppBar(title: Text('Create a Product')),
      body: ProductForm(
        product: Product(),
        onSubmit: (Product product) async {
          final doc = await service.create(product);
          if (product.file != null) {
            final task = service.upload(doc.id, product.file);
            final snapshot = await task.onComplete;
            product.image = await snapshot.ref.getDownloadURL();
            await service.update(doc.id, product);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
