import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

import 'activity_list.dart';
import 'activity_suggestion_list.dart';

class DefaultActivityView extends StatelessWidget {
  const DefaultActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activities you may interest',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'See more',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 380, child: ActivitySuggestionList()),
        const SizedBox(
          height: 48,
        ),
        Text(
          'More Activities',
          style: context.theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        const ActivityList(),
      ],
    );
  }
}
