import 'package:flutter/material.dart';
import '../intl.dart';
import '../image/form.dart';
import './model.dart';

class ProductForm extends StatelessWidget {
  final intl = const Intl('seller.product-form');
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
                  product.file = imgForm.file;
                  product.image = imgForm.url;
                },
              ),

              /// NAME ///
              TextFormField(
                initialValue: product.name,
                decoration: InputDecoration(
                  labelText: intl.string(context, 'name-label'),
                  hintText: intl.string(context, 'name-hint'),
                ),
                keyboardType: TextInputType.text,
                onSaved: (String name) => product.name = name,
              ),

              /// PRICE ///
              TextFormField(
                initialValue: product.price?.toString(),
                decoration: InputDecoration(
                  labelText: intl.string(context, 'price-label'),
                  hintText: intl.string(context, 'price-hint'),
                ),
                keyboardType: TextInputType.number,
                onSaved: (String price) => product.price = double.parse(price),
              ),

              /// STOCK ///
              TextFormField(
                initialValue: product.stock?.toString(),
                decoration: InputDecoration(
                  labelText: intl.string(context, 'stock-label'),
                  hintText: intl.string(context, 'stock-hint'),
                ),
                keyboardType: TextInputType.number,
                onSaved: (String stock) => product.stock = int.parse(stock),
              ),

              /// UNIT ///
              DropdownButtonFormField(
                value: product.unit,
                decoration: InputDecoration(
                  labelText: intl.string(context, 'unit-label'),
                  hintText: intl.string(context, 'unit-hint'),
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
                child: intl.text('submit'),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  _formKey.currentState.save();
                  onSubmit(product);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
