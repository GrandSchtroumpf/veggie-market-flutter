import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './market/list.dart';
import './market/view.dart';
import './market/bucket.dart';
import './dashboard/list.dart';
import './dashboard/create.dart';
import './dashboard/edit.dart';
import './auth/login.dart';
import './auth/profile.dart';
import './service.dart';

void main() {
  runApp(Root());
}

class Root extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          throw (snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ServiceProvider(child: App());
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/m/list',
        routes: {
          '/login': (ctx) => Login(),
          '/profile': (ctx) => Profile(),
          '/m/bucket': (ctx) => MarketBucket(),
          '/m/list': (ctx) => MarketList(),
          '/m/view': (ctx) => MarketView(),
          '/d/list': (ctx) => ProductList(),
          '/d/create': (ctx) => ProductCreate(),
          '/d/edit': (ctx) => ProductEdit(),
        },
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
