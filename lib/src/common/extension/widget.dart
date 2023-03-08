import 'package:flutter/material.dart';

extension WidgetExtension on List<Widget?> {
  List<Widget> padding(EdgeInsetsGeometry padding) {
    List<Widget> res = [];
    for (var value in this) {
      if (value == null) {
        continue;
      }
      res.add(Padding(padding: padding, child: value));
    }
    return res;
  }
}
