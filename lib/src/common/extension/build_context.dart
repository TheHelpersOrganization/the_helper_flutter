import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension BuildContextExtension on BuildContext {
  String get currentRoute => GoRouter.of(this).location;

  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  NavigatorState get navigator => Navigator.of(this);
}
