import 'package:flutter/material.dart';
import '../image/form.dart';
import './model.dart';

class SellerForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Seller seller;
  final Function onSubmit;

  SellerForm({Key key, this.seller, this.onSubmit}) : super(key: key);

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
                initialValue: ImgForm(seller.image),
                onSaved: (ImgForm imgForm) {
                  seller.file = imgForm.file;
                  seller.image = imgForm.url;
                },
              ),

              /// NAME ///
              TextFormField(
                initialValue: seller.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'The name of the seller',
                ),
                keyboardType: TextInputType.text,
                onSaved: (String name) => seller.name = name,
              ),

              /// SAVE ///
              RaisedButton(
                child: Text('Save'),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  _formKey.currentState.save();
                  onSubmit(seller);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
