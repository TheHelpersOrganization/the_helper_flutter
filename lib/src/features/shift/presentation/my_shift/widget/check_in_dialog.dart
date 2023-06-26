import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/controller/my_shift_controller.dart';

class CheckInDialog extends ConsumerWidget {
  final Shift shift;

  const CheckInDialog({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Check-in'),
      content: Text.rich(
        TextSpan(
          text: 'Do you want check-in shift ',
          children: [
            TextSpan(
              text: shift.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '?'),
          ],
        ),
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
            ref.read(checkInControllerProvider.notifier).checkIn(
                  shiftId: shift.id,
                );
          },
          child: const Text('Check-in'),
        ),
      ],
    );
  }
}
