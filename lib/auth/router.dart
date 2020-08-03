import 'package:flutter/material.dart';
import '../router.dart';
import './login.dart';

final authRoutes = NavigatorOptions(
  label: 'auth',
  icon: Icons.person,
  canDisplay: (context) => true,
  canActivate: (context) => true,
  routes: {
    '/login': (context) => Login(),
    '/not-found': (context) => Login(),
  },
);
