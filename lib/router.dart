import 'package:flutter/material.dart';

class NavigatorOptions {
  @required
  final Map<String, Widget Function(BuildContext)> routes;
  @required
  final String label;
  final IconData icon;
  final bool Function(BuildContext) canDisplay;
  final bool Function(BuildContext) canActivate;
  NavigatorOptions({
    this.label,
    this.icon,
    this.canDisplay,
    this.canActivate,
    this.routes,
  });
}
