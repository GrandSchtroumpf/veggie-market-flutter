import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends InheritedWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService({Key key, @required Widget child})
      : super(key: key, child: child);

  static AuthService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthService>();
  }

  @override
  bool updateShouldNotify(AuthService old) => true;

  get isConnected {
    return this.user$.map((user) => user != user);
  }

  get user$ {
    return this._auth.onAuthStateChanged;
  }

  getUser() {
    return this._auth.currentUser();
  }

  login(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
