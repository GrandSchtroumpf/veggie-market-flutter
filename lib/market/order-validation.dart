import 'package:flutter/material.dart';
import '../auth/login.dart';

class OrderValidation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String email;
    return Scaffold(
      appBar: AppBar(title: Text('Order')),
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
                    child: Text('We need an email to identify your order.'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String value) => email = value,
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      hintText: 'email used to retrieve your order.',
                      border: new OutlineInputBorder(),
                    ),
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
                    child: Text('Or use an account.'),
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
                    child: Text('Signin or Signup'),
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
