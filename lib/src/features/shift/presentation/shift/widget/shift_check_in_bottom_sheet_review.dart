import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

class ShiftCheckInBottomSheetReview extends StatelessWidget {
  final Shift shift;
  final ShiftVolunteer volunteer;

  const ShiftCheckInBottomSheetReview({
    super.key,
    required this.volunteer,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    final skill = shift.shiftSkills?.firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            'Review',
            style: context.theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.comment_outlined),
          title: volunteer.reviewNote != null
              ? Text(volunteer.reviewNote!)
              : const Text('No comment'),
          titleTextStyle: context.theme.textTheme.bodyMedium,
        ),
        ListTile(
          leading: const Icon(Icons.percent_outlined),
          title: Text(
            'Completion: ${(volunteer.completion * 100).toStringAsFixed(0)}%',
          ),
          titleTextStyle: context.theme.textTheme.bodyMedium,
        ),
        if (skill != null && volunteer.completion > 0)
          ListTile(
            leading: const Icon(Icons.bolt_outlined),
            title: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Text('Skill:'),
                Chip(
                  avatar: const Icon(Icons.wb_sunny_outlined),
                  label: Text(
                    '${skill.skill!.name} ',
                  ),
                ),
                Text(
                  '+${(skill.hours! * volunteer.completion).toStringAsFixed(1)}h',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            titleTextStyle: context.theme.textTheme.bodyMedium,
          ),
      ],
    );
  }
}
