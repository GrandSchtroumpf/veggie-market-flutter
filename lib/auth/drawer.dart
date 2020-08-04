import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot) {
        FirebaseUser user = snapshot.data;
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(user.email),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                title: Text('Profile'),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/profile'),
              ),
              ListTile(
                title: Text('Dashboard'),
                onTap: () => Navigator.pushReplacementNamed(context, '/d/list'),
              ),
            ],
          ),
        );
      },
    );
  }
}
