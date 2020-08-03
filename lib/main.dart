import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './auth/router.dart';
import './marketplace/router.dart';
import './dashboard/router.dart';
import './router.dart';
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
        home: Shell([
          marketplaceRoutes,
          authRoutes,
          dashboardRoutes,
        ]),
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}

class Shell extends StatefulWidget {
  final List<NavigatorOptions> options;
  Shell(this.options);
  @override
  createState() => ShellState(options);
}

class ShellState extends State<Shell> {
  final List<NavigatorOptions> options;
  int currentIndex = 0;
  ShellState(this.options);

  /// Create a navigator Widget based on an option ///
  getNavigator(NavigatorOptions option) {
    return Navigator(
      key: GlobalKey<NavigatorState>(debugLabel: option.label),
      onGenerateRoute: (setting) {
        String name = option.routes.containsKey(setting.name)
            ? setting.name
            : '/not-found';
        return MaterialPageRoute(
          builder: option.routes[name],
          maintainState: true,
          settings: setting,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    options.removeWhere((option) => !option.canDisplay(context));
    return Scaffold(
      body: getNavigator(options[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: options.map((option) {
          return BottomNavigationBarItem(
            icon: Icon(option.icon),
            title: Text(option.label),
          );
        }).toList(),
      ),
    );
  }
}
