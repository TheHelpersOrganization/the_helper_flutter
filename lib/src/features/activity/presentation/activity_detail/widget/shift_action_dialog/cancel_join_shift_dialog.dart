import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';

class CancelJoinShiftDialog extends ConsumerWidget {
  final int activityId;
  final int shiftId;
  final String? shiftName;

  const CancelJoinShiftDialog({
    super.key,
    required this.activityId,
    required this.shiftId,
    this.shiftName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Cancel registration'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Your registration is waiting for approval.'),
          shiftName != null
              ? Text.rich(
                  TextSpan(
                      text: 'Do you want to cancel registration to ',
                      children: [
                        TextSpan(
                          text: shiftName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: '?'),
                      ]),
                )
              : const Text(
                  'Do you want to cancel registration to this shift?',
                ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            context.pop();
            ref
                .read(cancelJoinShiftControllerProvider.notifier)
                .cancelJoinShift(
                  shiftId: shiftId,
                );
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
