import 'package:flutter/material.dart';
import 'package:the_helper/src/router/router.dart';

class DrawerItemModel {
  final AppRoute? route;
  final String title;
  final IconData icon;
  final void Function(BuildContext context)? onTap;

  const DrawerItemModel({
    this.route,
    required this.title,
    required this.icon,
    this.onTap,
  });
}
