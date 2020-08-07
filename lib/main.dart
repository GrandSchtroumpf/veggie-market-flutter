import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:veggie_market/dashboard/seller-edit.dart';
import './market/product-list.dart';
import './market/product-view.dart';
import 'market/bucket.dart';
import 'market/order-list.dart';
import './dashboard/list.dart';
import './dashboard/create.dart';
import './dashboard/edit.dart';
import './dashboard/order.dart';
import './auth/login.dart';
import './auth/profile.dart';
import 'service-provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

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
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(basePath: 'assets/i18n'),
            missingTranslationHandler: (key, locale) {
              print("Missing Key: $key, languageCode: ${locale.languageCode}");
            },
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('fr', ''),
        ],
        initialRoute: '/m/list',
        routes: {
          '/login': (ctx) => Login(),
          '/profile': (ctx) => Profile(),
          '/m/bucket': (ctx) => BuyerBucket(),
          '/m/list': (ctx) => BuyerProductList(),
          '/m/view': (ctx) => BuyerProductView(),
          '/m/order': (ctx) => BuyerOrderList(),
          '/d/list': (ctx) => ProductList(),
          '/d/create': (ctx) => ProductCreate(),
          '/d/edit': (ctx) => ProductEdit(),
          '/d/order': (ctx) => SellerOrderList(),
          '/seller/edit': (ctx) => SellerEdit(),
        },
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
