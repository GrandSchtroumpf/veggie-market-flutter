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
        // Used when keyboard is opened
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// IMAGE ///
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

              /// NAME ///
              TextFormField(
                initialValue: product.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'The name of the product',
                ),
                keyboardType: TextInputType.text,
                onSaved: (String name) => product.name = name,
              ),

              /// PRICE ///
              TextFormField(
                initialValue: product.price.toString(),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: '€ / unit',
                ),
                keyboardType: TextInputType.number,
                onSaved: (String price) => product.price = int.parse(price),
              ),

              /// STOCK ///
              TextFormField(
                initialValue: product.stock.toString(),
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  hintText: 'Current amount available',
                ),
                keyboardType: TextInputType.number,
                onSaved: (String stock) => product.stock = int.parse(stock),
              ),

              /// UNIT ///
              DropdownButtonFormField(
                value: product.unit,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  hintText: 'kg or per unit',
                ),
                items: [
                  DropdownMenuItem(
                    child: Text('kg'),
                    value: 'kg',
                  ),
                  DropdownMenuItem(
                    child: Text('unit'),
                    value: 'unit',
                  ),
                ],
                onChanged: (String value) => product.unit = value,
                onSaved: (String value) => product.unit = value,
              ),

              /// SAVE ///
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
      ),
    );
  }
}
