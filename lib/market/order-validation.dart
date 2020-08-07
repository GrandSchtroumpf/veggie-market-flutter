import 'package:flutter/material.dart';
import '../intl.dart';
import '../auth/login.dart';

class OrderValidation extends StatelessWidget {
  final intl = const Intl('buyer.order-validation');

  @override
  Widget build(BuildContext context) {
    String email;
    return Scaffold(
      appBar: AppBar(title: intl.text('title')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: intl.text('description'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String value) => email = value,
                    decoration: InputDecoration(
                      labelText: intl.string(context, 'email-text'),
                      hintText: intl.string(context, 'email-hint'),
                      border: new OutlineInputBorder(),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => Navigator.pop(context, email),
                    child: intl.text('email-submit'),
                  ),
                ],
              ),
            ),
            Divider(thickness: 2.0),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: intl.text('use-account'),
                  ),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () async {
                      email = await showDialog(
                        context: context,
                        builder: (context) => Login(),
                      );
                      if (email != null) {
                        Navigator.pop(context, email);
                      }
                    },
                    child: intl.text('connection'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
