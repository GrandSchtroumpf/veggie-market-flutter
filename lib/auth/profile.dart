import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot) {
        FirebaseUser user = snapshot.data;
        return Column(
          children: [
            user.photoUrl != null
                ? Image.network(user.photoUrl)
                : Image.asset('assets/img/avatar.png'),
            Text(user.displayName),
            Text(user.email),
          ],
        );
      },
    );
  }
}
