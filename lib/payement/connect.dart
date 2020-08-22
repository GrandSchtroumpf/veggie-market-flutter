import 'package:flutter/material.dart';
import '../service-provider.dart';

class StripeConnect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = ServiceProvider.of(context).payment;
    return RaisedButton(
      child: Text('Connect to Stripe'),
      onPressed: () async {
        final account = await service.createAccount();
        print(account);
      },
    );
  }
}
