import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './avatar.dart';

class AuthDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseUser user;
  AuthDrawer(this.user);
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      Navigator.pop(context);
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [avatar(user), Text(user.email)],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => Navigator.pushReplacementNamed(context, '/d/list'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Market'),
            onTap: () => Navigator.pushReplacementNamed(context, '/m/list'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Signout'),
            onTap: () => _auth.signOut(),
          ),
        ],
      ),
    );
  }
}
