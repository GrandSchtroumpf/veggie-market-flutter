import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninForm {
  String email;
  String password;
}

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _form = SigninForm();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get email {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      onSaved: (String email) => _form.email = email,
    );
  }

  get password {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (String password) => _form.password = password,
    );
  }

  get confirm {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Confirm Password',
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: () => _formKey.currentState.validate(),
      validator: (String value) => _form.password == value
          ? null
          : 'Password does not match with the one provided',
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
        appBar: AppBar(
            title: Text('Connection'),
            bottom: TabBar(
              isScrollable: false,
              tabs: [
                Tab(text: 'Signin'),
                Tab(text: 'Signup'),
              ],
            )),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              /// SIGNIN ///
              shell([
                email,
                password,
                RaisedButton(
                  child: Text('Signin'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    _formKey.currentState.save();
                    await _auth.signInWithEmailAndPassword(
                      email: _form.email,
                      password: _form.password,
                    );
                    Navigator.pop(context, _form.email);
                  },
                ),
              ]),

              /// SIGNUP ///
              shell([
                email,
                password,
                confirm,
                RaisedButton(
                  child: Text('Signup'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    _formKey.currentState.save();
                    if (_formKey.currentState.validate()) {
                      await _auth.createUserWithEmailAndPassword(
                        email: _form.email,
                        password: _form.password,
                      );
                      Navigator.pop(context, _form.email);
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
}
