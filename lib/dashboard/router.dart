import 'package:flutter/material.dart';
import '../product/list.dart';
import '../product/create.dart';
import '../product/edit.dart';

import '../router.dart';

final dashboardRoutes = NavigatorOptions(
  label: 'dashboard',
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
