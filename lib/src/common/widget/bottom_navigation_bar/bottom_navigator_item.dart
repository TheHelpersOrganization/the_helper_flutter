import 'package:flutter/material.dart';

class NavBarTabItem extends BottomNavigationBarItem {
  const NavBarTabItem(
      {required this.initialLocation, required Widget icon, String? label})
      : super(icon: icon, label: label);

  /// The initial location/path
  final String initialLocation;
}