import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter/foundation.dart';
import './dashboard/seller-edit.dart';
import './market/product-list.dart';
import './market/product-view.dart';
import 'market/bucket.dart';
import 'market/order-list.dart';
import 'dashboard/product-list.dart';
import 'dashboard/product-create.dart';
import 'dashboard/product-edit.dart';
import 'dashboard/order-list.dart';
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
          // EMULATOR
          // Switch host based on platform.
          // String host = defaultTargetPlatform == TargetPlatform.android
          //     ? '10.0.2.2:8080'
          //     : 'localhost:8080';

          // // Set the host as soon as possible.
          // FirebaseFirestore.instance.settings = Settings(
          //   host: host,
          //   sslEnabled: false,
          //   persistenceEnabled: false,
          // );
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
          '/d/list': (ctx) => SellerProductList(),
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
