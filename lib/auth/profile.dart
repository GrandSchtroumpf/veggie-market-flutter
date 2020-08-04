import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './avatar.dart';

class Profile extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        FirebaseUser user = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Column(
            children: [
              avatar(user),
              Text(user.email),
            ],
          ),
        );
      },
    );
  }
}
