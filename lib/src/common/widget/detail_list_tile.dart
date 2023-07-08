import 'package:flutter/material.dart';

class DetailListTile extends StatelessWidget {
  const DetailListTile({
    super.key, 
    required this.label, 
    this.value = 'Undefined',
    this.labelStyle,
    this.valueStyle,
  });
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: labelStyle),
            Text(value,style: valueStyle)
          ]),
    );
  }
}
