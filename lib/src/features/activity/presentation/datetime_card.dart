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
    // return Container(
    //   padding: const EdgeInsets.all(8),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(8),
    //     color: Colors.white,
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.grey.withOpacity(0.5),
    //         spreadRadius: 5,
    //         blurRadius: 7,
    //         offset: const Offset(
    //           0,
    //           3,
    //         ), // changes position of shadow
    //       )
    //     ],
    //   ),
    //   child: Column(
    //     children: [
    //       Text(
    //         '${DateFormat('MMM').format(DateTime(0, dateTime.month))} ${dateTime.day}',
    //         style: const TextStyle(
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       Text(
    //         '${dateTime.hour}:${dateTime.minute}',
    //       ),
    //     ],
    //   ),
    // );

    return Card(
      elevation: 2,
      color: context.theme.colorScheme.surface,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              '${DateFormat('MMM').format(DateTime(0, dateTime.month))} ${dateTime.day}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${dateTime.hour}:${dateTime.minute}',
            ),
          ],
        ),
      ),
    );
  }
}
