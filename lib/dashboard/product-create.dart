import 'package:flutter/material.dart';
import '../intl.dart';
import '../service-provider.dart';
import '../product/model.dart';
import '../product/form.dart';

class ProductCreate extends StatelessWidget {
  final intl = const Intl('seller-create');
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).product;
    return Scaffold(
      appBar: AppBar(title: intl.text('title')),
      body: ProductForm(
        product: Product(),
        onSubmit: (Product product) async {
          String id = service.createId();
          if (product.file != null) {
            final task = await service.upload(id, product.file);
            final snapshot = await task.onComplete;
            product.image = await snapshot.ref.getDownloadURL();
          }
          await service.setDoc(id, product);
          Navigator.pop(context);
        },
      ),
    );
  }
}