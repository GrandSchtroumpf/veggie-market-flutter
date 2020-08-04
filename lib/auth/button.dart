import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';
import 'profile.dart';

class AuthButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot) {
        FirebaseUser user = snapshot.data;
        if (user == null) {
          return IconButton(
            onPressed: () => showDialog(
              context: context,
              child: Login(),
            ),
            icon: Icon(Icons.account_circle),
          );
        } else {
          return Center(
            child: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: CircleAvatar(
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl)
                    : AssetImage('assets/img/avatar.png'),
              ),
            ),
          );
        }
      },
    );
  }
}
