import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/utils/shift.dart';

class ShiftTitle extends StatelessWidget {
  final Activity activity;
  final Shift shift;

  const ShiftTitle({
    super.key,
    required this.activity,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            text: shift.name,
            style: context.theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            children: [
              const WidgetSpan(
                child: SizedBox(
                  width: 8,
                ),
              ),
              WidgetSpan(
                child: getShiftStatusLabel(shift.status),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Text('Organized by'),
            TextButton(
              onPressed: () {},
              child: Text(
                activity.organization?.name ?? 'Unknown Organization',
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ],
    );
  }
}
