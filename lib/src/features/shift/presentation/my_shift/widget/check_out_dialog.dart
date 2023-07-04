import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/controller/my_shift_controller.dart';

class CheckOutDialog extends ConsumerWidget {
  final Shift shift;

  const CheckOutDialog({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Check-out'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              text: 'Do you want check-out shift ',
              children: [
                TextSpan(
                  text: shift.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          if (shift.endTime.isAfter(DateTime.now())) ...[
            const SizedBox(height: 12),
            const Text(
              'Shift has not ended yet.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const Text(
              'You will be able to check-out only once.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ]
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
            ref.read(checkOutControllerProvider.notifier).checkOut(
                  shiftId: shift.id,
                );
          },
          child: const Text('Check-out'),
        ),
      ],
    );
  }
}
