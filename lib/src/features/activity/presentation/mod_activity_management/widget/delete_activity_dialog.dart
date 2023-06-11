import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';

class DeleteActivityDialog extends ConsumerWidget {
  final int activityId;

  const DeleteActivityDialog({
    super.key,
    required this.activityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Delete activity'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You are about to delete this activity.',
          ),
          Text(
            'All shifts and participants will be removed.',
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
            ref.read(deleteActivityControllerProvider.notifier).deleteActivity(
                  activityId: activityId,
                );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
