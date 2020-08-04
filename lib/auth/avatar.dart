import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

CircleAvatar avatar(FirebaseUser user) {
  return CircleAvatar(
    backgroundImage: user.photoUrl != null
        ? NetworkImage(user.photoUrl)
        : AssetImage('assets/img/avatar.png'),
  );
}
