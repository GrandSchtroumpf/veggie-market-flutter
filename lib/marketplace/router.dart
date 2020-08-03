import 'package:flutter/material.dart';
import './list.dart';

import '../router.dart';

final marketplaceRoutes = NavigatorOptions(
  label: 'marketplace',
  icon: Icons.shopping_cart,
  canDisplay: (context) => true,
  canActivate: (context) => true,
  routes: {
    '/': (ctx) => ProductList(),
  },
);
