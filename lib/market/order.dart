import 'package:flutter/material.dart';
import '../auth/login.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order')),
      body: Column(
        children: [
          Text('Enter an email'),
          TextFormField(
            initialValue: '',
          ),
          Text('Or use an account'),
          RaisedButton(
            onPressed: () async {
              String email = await showDialog(
                context: context,
                builder: (context) => Login(),
              );
              if (email != null) {
                Navigator.pop(context, email);
              }
            },
            child: Text('Signin or Signup'),
          )
        ],
      ),
    );
  }
}
