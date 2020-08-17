import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import Stripe from 'stripe';

const config = functions.config();

admin.initializeApp(config.firebase);

export const createPaymentIntent = functions.https.onCall((data, context) => {

  const db = admin.firestore();
  db.settings({ timestampInSnapshots: true })
  const stripe = new Stripe(config.stripe.key, {
    apiVersion: '2020-03-02',
  });

  return stripe.paymentIntents.create({
    amount: data.amount,
    currency: data.currency,
    payment_method_types: ['card'],
  });
});