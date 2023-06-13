import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';

class JoinShiftDialog extends ConsumerWidget {
  final int activityId;
  final int shiftId;
  final String? shiftName;

  const JoinShiftDialog({
    super.key,
    required this.activityId,
    required this.shiftId,
    this.shiftName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Join shift'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          shiftName != null
              ? Text.rich(
                  TextSpan(text: 'Do you want to join ', children: [
                    TextSpan(
                      text: shiftName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '?'),
                  ]),
                )
              : const Text(
                  'Do you want to join this shift?',
                ),
          const Text(
            'You registration will be waiting for approval by manager of this shift.',
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
            ref.read(joinShiftControllerProvider.notifier).joinShift(
                  shiftId: shiftId,
                );
          },
          child: const Text('Join'),
        ),
      ],
    );
  }
}
