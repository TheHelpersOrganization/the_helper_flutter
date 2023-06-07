import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';

class ActivityTitle extends StatelessWidget {
  final Activity activity;

  const ActivityTitle({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          activity.name!,
          style: context.theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
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
        )
      ],
    );
  }
}
