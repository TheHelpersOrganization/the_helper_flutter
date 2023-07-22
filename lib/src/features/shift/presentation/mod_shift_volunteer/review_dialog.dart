import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_controller.dart';

class ReviewDialog extends ConsumerWidget {
  final ShiftVolunteer volunteer;
  const ReviewDialog({
    required this.volunteer,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sliderValue = ref.watch(sliderValueProvider);
    final textValue = ref.watch(textValueProvider);
    final isReviewed = volunteer.completion != 0 ||
        (volunteer.reviewNote != null && volunteer.reviewNote!.isNotEmpty);

    return AlertDialog(
      scrollable: true,
      title: Center(child: Text('Review ${volunteer.profile!.username}')),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            ref
                .read(changeVolunteerStatusControllerProvider.notifier)
                .reviewVolunteer(
                  volunteer,
                  completion: sliderValue,
                  reviewNote: textValue,
                );
          },
          child: isReviewed ? const Text('Update') : const Text('Submit'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Completion",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${sliderValue.toInt().toString()}%',
                        ),
                      ],
                    ),
                    Slider(
                      value: sliderValue,
                      min: 0.0,
                      max: 100.0,
                      divisions: 5,
                      onChanged: (double value) {
                        ref.read(sliderValueProvider.notifier).state = value;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: null,
                      initialValue: textValue,
                      onChanged: (value) {
                        ref.read(textValueProvider.notifier).state = value;
                      },
                      decoration: const InputDecoration(
                        labelText: "Review Note",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
