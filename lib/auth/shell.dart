import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login.dart';
import './drawer.dart';
import './avatar.dart';

class AuthShell extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Widget body;
  final Widget floatingActionButton;
  final String title;

  AuthShell({this.title, this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('An error occured ' + snapshot.error.toString());
        }

        /// NO USER ///
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                onPressed: () => showDialog(
                  context: context,
                  child: Login(),
                ),
                icon: Icon(Icons.account_circle),
              ),
            ),
            body: body,
            floatingActionButton: floatingActionButton,
          );
        }

        /// WITH USER ///
        FirebaseUser user = snapshot.data;
        return Scaffold(
          key: _key,
          appBar: AppBar(
            leading: Center(
              child: GestureDetector(
                onTap: () => _key.currentState.openDrawer(),
                child: avatar(user),
              ),
            ),
            title: Text(title),
          ),
          drawer: Drawer(
            child: AuthDrawer(user),
          ),
          body: body,
          floatingActionButton: floatingActionButton,
        );
      },
    );
  }
}
