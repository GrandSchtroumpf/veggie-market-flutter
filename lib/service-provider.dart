import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'seller/service.dart';
import 'product/service.dart';
import 'order/service.dart';
import 'order/bucket.dart';

/// Provide the list of service for the app
/// Create the service only on demand
class ServiceProvider extends InheritedWidget {
  final Trace trace = FirebasePerformance.instance.newTrace("test_trace");
  final user$ =
      FirebaseAuth.instance.onAuthStateChanged.shareReplay(maxSize: 1);
  final seller = SellerService();
  final product = ProductService();
  final order = OrderService();
  final bucket = Bucket();

  ServiceProvider({Key key, @required Widget child})
      : super(key: key, child: child) {
    trace.start();
  }

  static ServiceProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ServiceProvider>();
  }

  @override
  bool updateShouldNotify(ServiceProvider old) => true;
}
