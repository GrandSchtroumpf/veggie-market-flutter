import 'package:flutter/material.dart';
import 'list.dart';
import 'create.dart';
import 'edit.dart';

import '../router.dart';

final dashboardRoutes = NavigatorOptions(
  label: 'Dashboard',
  icon: Icons.dashboard,
  canDisplay: (context) => true,
  canActivate: (context) => true,
  routes: {
    '/': (ctx) => ProductList(),
    '/create': (ctx) => CreatePage(),
    '/edit': (ctx) => EditPage(),
    '/not-found': (context) => ProductList(),
  },
);
