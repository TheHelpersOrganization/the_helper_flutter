import 'package:flutter/material.dart';

class DetailListTile extends StatelessWidget{
  const DetailListTile({super.key, required this.label, this.value = 'Undefined'});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value)]),
    );
  }
}