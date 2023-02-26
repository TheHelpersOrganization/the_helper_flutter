import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

extension Router on BuildContext {
  String currentRoute() {
    return GoRouter.of(this).location;
  }
}
