import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class DateTimeCard extends StatelessWidget {
  final DateTime dateTime;

  const DateTimeCard({
    super.key,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: context.theme.colorScheme.surface,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              DateFormat('MMM dd').format(dateTime),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('hh:mm').format(dateTime),
            ),
          ],
        ),
      ),
    );
  }
}
