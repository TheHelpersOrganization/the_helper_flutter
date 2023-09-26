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
        // alignment: WrapAlignment.spaceBetween,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          const Flexible(child: SizedBox(width: 4)),
          Flexible(
            flex: 2,
            child: Text(
              value,
              style: valueStyle,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
