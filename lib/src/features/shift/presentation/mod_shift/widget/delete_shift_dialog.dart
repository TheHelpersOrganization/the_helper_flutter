import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/controller/shift_controller.dart';

class DeleteShiftDialog extends ConsumerWidget {
  final int activityId;
  final int shiftId;

  const DeleteShiftDialog({
    super.key,
    required this.activityId,
    required this.shiftId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Delete Shift'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You are about to delete this shift.',
          ),
          Text(
            'All participants will be removed.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'This action cannot be undone.',
            style: TextStyle(fontWeight: FontWeight.bold),
          )
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
            ref.read(deleteShiftControllerProvider.notifier).deleteShift(
                  activityId: activityId,
                  shiftId: shiftId,
                );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
