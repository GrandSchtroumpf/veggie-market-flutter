import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './product/list.dart';
import './product/create.dart';
import './product/edit.dart';
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
        initialRoute: '/list',
        routes: {
          '/list': (ctx) => ProductList(),
          '/create': (ctx) => CreatePage(),
          '/edit': (ctx) => EditPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ProductList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/create'),
      ),
    );
  }
}
