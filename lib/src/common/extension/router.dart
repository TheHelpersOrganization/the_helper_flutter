import 'package:flutter/cupertino.dart';

extension Router on BuildContext {
  String? currentRoute() {
    return ModalRoute.of(this)?.settings.name;
  }
}
