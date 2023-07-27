import 'package:flutter/material.dart';
import 'package:the_helper/src/router/router.dart';

class DrawerItemModel {
  final AppRoute? route;
  final Map<String, dynamic>? pathParameters;
  final List<DrawerItemModel>? subPaths;
  final String title;
  final IconData icon;
  final void Function(BuildContext context)? onTap;

  const DrawerItemModel({
    this.route,
    this.pathParameters,
    this.subPaths,
    required this.title,
    required this.icon,
    this.onTap,
  });
}
