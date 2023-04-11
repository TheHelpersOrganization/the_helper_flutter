import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/router/router.dart';

class DrawerItemModel {
  final AppRoute? route;
  final List<DrawerItemModel>? subPaths;
  final String title;
  final IconData icon;

  const DrawerItemModel({
    this.route,
    this.subPaths,
    required this.title,
    required this.icon,
  });
}
