import 'package:flutter/material.dart';

extension WidgetExtension on List<Widget?> {
  List<Widget> padding(
    EdgeInsetsGeometry padding, {
    bool ignoreFirst = false,
    bool ignoreLast = false,
    EdgeInsetsGeometry? firstPadding,
    EdgeInsetsGeometry? lastPadding,
  }) {
    List<Widget> res = [];
    final lastIndex = length - 1;
    for (int i = 0; i < length; i++) {
      Widget? value = this[i];
      if (value == null) {
        continue;
      }
      if (i == 0 && ignoreFirst) {
        res.add(value);
        continue;
      }
      if (i == lastIndex && ignoreLast) {
        res.add(value);
        continue;
      }
      if (i == 0 && firstPadding != null) {
        res.add(Padding(
          padding: firstPadding,
          child: value,
        ));
        continue;
      }
      if (i == lastIndex && lastPadding != null) {
        res.add(Padding(
          padding: lastPadding,
          child: value,
        ));
        continue;
      }
      res.add(Padding(padding: padding, child: value));
    }
    return res;
  }
}
