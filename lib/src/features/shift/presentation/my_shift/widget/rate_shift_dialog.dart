import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/dialog/dialog_with_header.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/controller/my_shift_controller.dart';

final currentRatingProvider = StateProvider.autoDispose<int?>((ref) => null);
final currentCommentProvider =
    StateProvider.autoDispose<String?>((ref) => null);

class RateShiftDialog extends ConsumerWidget {
  final ShiftVolunteer volunteer;

  const RateShiftDialog({
    super.key,
    required this.volunteer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rateShiftState = ref.watch(rateShiftControllerProvider);
    final currentRating =
        ref.watch(currentRatingProvider) ?? volunteer.shiftRating ?? 5;
    final currentComment =
        ref.watch(currentCommentProvider) ?? volunteer.shiftRatingComment;

    final starButtons = List.generate(5, (index) {
      final rate = index + 1;
      return IconButton(
        icon: Icon(
          Icons.star,
          color: currentRating >= rate ? Colors.amber : Colors.grey,
        ),
        onPressed: () {
          ref.read(currentRatingProvider.notifier).state = rate;
        },
      );
    });

    return DialogWithHeader(
      enableCloseButton: !rateShiftState.isLoading,
      titleText: 'Rate shift',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: starButtons,
          ),
          const SizedBox(height: 24),
          TextFormField(
            initialValue: currentComment,
            decoration: const InputDecoration(
              labelText: 'Comment',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (value) {
              ref.read(currentCommentProvider.notifier).state = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: rateShiftState.isLoading
              ? null
              : () {
                  context.pop();
                },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: rateShiftState.isLoading
              ? null
              : () async {
                  await ref
                      .read(rateShiftControllerProvider.notifier)
                      .rateShift(
                        shiftId: volunteer.shiftId,
                        rating: currentRating,
                        comment: currentComment,
                      );
                  if (!context.mounted) {
                    return;
                  }
                  context.pop();
                },
          child: Text(rateShiftState.isLoading ? 'Submitting' : 'Submit'),
        ),
      ],
    );
  }
}
