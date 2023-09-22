import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/alert.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

class OngoingShiftAlert extends StatelessWidget {
  final Shift ongoingShift;

  const OngoingShiftAlert({
    super.key,
    required this.ongoingShift,
  });

  @override
  Widget build(BuildContext context) {
    return Alert(
      leading: const Icon(
        Icons.info_outline,
      ),
      message: Text.rich(
        TextSpan(
          text: 'You have an ongoing shift ',
          children: [
            TextSpan(
              text: ongoingShift.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ' now'),
          ],
        ),
        maxLines: 2,
      ),
      action: IconButton(
        onPressed: () {
          context.goNamed(AppRoute.shift.name, pathParameters: {
            'activityId': ongoingShift.activityId.toString(),
            'shiftId': ongoingShift.id.toString(),
          });
        },
        icon: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}
