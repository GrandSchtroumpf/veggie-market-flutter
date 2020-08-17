import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../intl.dart';
import '../env.dart';

class Payment extends StatelessWidget {
  final intl = const Intl('buyer.order-validation');
  final intent = CloudFunctions.instance
      .getHttpsCallable(functionName: 'createPaymentIntent');

  @override
  Widget build(BuildContext context) {
    StripePayment.setOptions(
      StripeOptions(publishableKey: STRIPE_PUBLIC_KEY),
    );
    return Scaffold(
      appBar: AppBar(title: intl.text('title')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: intl.text('description'),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text('Native Payment'),
                    onPressed: () => requestPayment(context),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  requestPayment(BuildContext context) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      if (paymentMethod != null) {
        // multipliying with 100 to change $ to cents
        double amount = 100 * 100.0;
        final res = await intent.call({'amount': amount, 'currency': 'eur'});
        //function for confirmation for payment
        confirmDialog(context, res.data["client_secret"], paymentMethod);
      }
    } catch (err) {
      print(err);
    }
  }

  confirmDialog(
    BuildContext context,
    String clientSecret,
    PaymentMethod paymentMethod,
  ) {
    final confirm = AlertDialog(
      title: Text("Confirm Payement"),
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [Text("Make Payment"), Text("Charge amount: 100€")],
        ),
      ),
      actions: [
        new RaisedButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
            final snackBar = SnackBar(
              content: Text('Payment Cancelled'),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          },
        ),
        new RaisedButton(
          child: new Text('Confirm'),
          onPressed: () {
            Navigator.of(context).pop();
            confirmPayment(context, clientSecret, paymentMethod);
          },
        ),
      ],
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => confirm,
    );
  }

  confirmPayment(
    BuildContext context,
    String sec,
    PaymentMethod paymentMethod,
  ) {
    StripePayment.confirmPaymentIntent(
      PaymentIntent(clientSecret: sec, paymentMethodId: paymentMethod.id),
    ).then((val) {
      // ADD PAYMENT TO FIRESTORE HERE
      final snackBar = SnackBar(
        content: Text('Payment Successfull'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
