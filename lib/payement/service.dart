import 'package:stripe_payment/stripe_payment.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../env.dart';

HttpsCallable callableFn(String name) {
  return CloudFunctions.instance.getHttpsCallable(functionName: name);
}

class PaymentService {
  final intent = callableFn('createPaymentIntent');
  final states = {};

  PaymentService() {
    StripePayment.setOptions(
      StripeOptions(publishableKey: STRIPE_PUBLIC_KEY),
    );
  }

  double toCent(double amount) {
    return 100 * amount;
  }

  requestPayment() async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      states[paymentMethod.id] = paymentMethod;
      double amount = toCent(100.0);
      final res = await intent.call({'amount': amount, 'currency': 'eur'});
      return res.data;
    } catch (err) {
      print(err);
    }
  }
}
