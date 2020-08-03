import 'package:flutter/cupertino.dart';

class AuthService extends InheritedWidget {
  AuthService({Key key, @required Widget child})
      : super(key: key, child: child);

  static AuthService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthService>();
  }

  @override
  bool updateShouldNotify(AuthService old) => true;
}
