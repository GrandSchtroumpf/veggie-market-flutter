import 'package:flutter/material.dart';
import '../image/form.dart';
import './model.dart';

class ProductForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Product product;
  final Function onSubmit;

  ProductForm({Key key, this.product, this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImgFormField(
              initialValue: ImgForm(product.image),
              onSaved: (ImgForm imgForm) {
                if (imgForm.deleted) {
                  product.image = null;
                  imgForm.url = null;
                }
                if (imgForm.file != null) {
                  product.file = imgForm.file;
                }
                product.image = imgForm.url;
              },
            ),
            TextFormField(
              initialValue: product.name,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'The name of the product',
              ),
              keyboardType: TextInputType.text,
              onSaved: (String name) => product.name = name,
            ),
            TextFormField(
              initialValue: product.price.toString(),
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: '€ / unit',
              ),
              keyboardType: TextInputType.number,
              onSaved: (String price) => product.price = int.parse(price),
            ),
            TextFormField(
              initialValue: product.stock.toString(),
              decoration: const InputDecoration(
                labelText: 'Stock',
                hintText: 'Current amount available',
              ),
              keyboardType: TextInputType.number,
              onSaved: (String stock) => product.stock = int.parse(stock),
            ),
            RaisedButton(
              child: Text('Save Product'),
              onPressed: () {
                _formKey.currentState.save();
                onSubmit(product);
                _formKey.currentState.reset();
              },
            ),
          ],
        ),
      ),
    );
  }
}
