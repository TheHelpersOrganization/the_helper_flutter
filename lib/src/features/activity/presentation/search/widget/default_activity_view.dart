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
        Text(
          'Activities you may interest',
          style: context.theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const SizedBox(height: 380, child: ActivitySuggestionList()),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(),
        ),
        Text(
          'More Activities',
          style: context.theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const ActivityList(),
      ],
    );
  }
}
