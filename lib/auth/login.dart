import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../intl.dart';

class SigninForm {
  String email;
  String password;
}

class Login extends StatelessWidget {
  final intl = const Intl('auth.login');
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _form = SigninForm();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  email(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      onSaved: (String email) => _form.email = email,
      validator: (String value) =>
          value.length > 0 ? null : intl.string(context, 'email-validator'),
    );
  }

  password(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: intl.string(context, 'password-label'),
        hintText: intl.string(context, 'password-hint'),
      ),
      obscureText: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (String password) => _form.password = password,
      validator: (String value) =>
          value.length >= 6 ? null : intl.string(context, 'password-validator'),
    );
  }

  confirm(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: intl.string(context, 'confirm-label'),
        hintText: intl.string(context, 'confirm-hint'),
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: () => _formKey.currentState.validate(),
      validator: (String value) => _form.password == value
          ? null
          : intl.string(context, 'confirm-validator'),
    );
  }

  shell(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: intl.text('title'),
            bottom: TabBar(
              isScrollable: false,
              tabs: [
                Tab(text: intl.string(context, 'signin')),
                Tab(text: intl.string(context, 'signup')),
              ],
            )),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              /// SIGNIN ///
              shell([
                email(context),
                password(context),
                RaisedButton(
                  child: intl.text('signin'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        _formKey.currentState.save();
                        await _auth.signInWithEmailAndPassword(
                          email: _form.email,
                          password: _form.password,
                        );
                        Navigator.pop(context, _form.email);
                      } catch (err) {
                        showSnackBar(err.code);
                      }
                    }
                  },
                ),
              ]),

              /// SIGNUP ///
              shell([
                email(context),
                password(context),
                confirm(context),
                RaisedButton(
                  child: intl.text('signup'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    _formKey.currentState.save();
                    if (_formKey.currentState.validate()) {
                      try {
                        await _auth.createUserWithEmailAndPassword(
                          email: _form.email,
                          password: _form.password,
                        );
                        Navigator.pop(context, _form.email);
                      } catch (err) {
                        showSnackBar(err.code);
                      }
                    }
                  },
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Future<SnackBarClosedReason> showSnackBar(String key) {
    final snackBar = SnackBar(
      content: intl.text(key),
      duration: Duration(seconds: 3),
    );
    return _scaffoldKey.currentState.showSnackBar(snackBar).closed;
  }
}
