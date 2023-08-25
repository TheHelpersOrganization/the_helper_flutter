import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/rating.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/rate_shift_dialog.dart';

class BottomSheetRating extends ConsumerWidget {
  final Shift shift;
  final ShiftVolunteer volunteer;

  const BottomSheetRating({
    super.key,
    required this.volunteer,
    required this.shift,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            'Rating',
            style: context.theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          trailing: FilledButton.tonal(
            onPressed: () {
              context.pop();
              showDialog(
                context: context,
                builder: (context) => RateShiftDialog(
                  volunteer: volunteer,
                ),
              );
            },
            child: const Text('Rate shift'),
          ),
        ),
        if (volunteer.shiftRating == null)
          const ListTile(
            leading: Icon(Icons.star_border_outlined),
            title: Text('No rating'),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Rating(
              rating: volunteer.shiftRating!,
            ),
          ),
        ListTile(
          title: volunteer.shiftRatingComment != null
              ? Text(volunteer.shiftRatingComment!)
              : const Text('No comment'),
          titleTextStyle: context.theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
