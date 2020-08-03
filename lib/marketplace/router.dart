import 'package:flutter/material.dart';
import './list.dart';
import './view.dart';

import '../router.dart';

final marketplaceRoutes = NavigatorOptions(
  label: 'Marketplace',
  icon: Icons.shopping_cart,
  canDisplay: (context) => true,
  canActivate: (context) => true,
  routes: {
    '/': (ctx) => ProductList(),
    '/view': (ctx) => ProductView(),
  },
);
