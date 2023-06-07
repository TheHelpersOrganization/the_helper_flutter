import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';

class ActivitySkill extends StatelessWidget {
  final Activity activity;

  const ActivitySkill({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills Required',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          activity.skills?.isNotEmpty == true
              ? 'Actual skill requirement depends on shift. Please check the shift details.'
              : 'No skill required',
          style: TextStyle(color: context.theme.colorScheme.secondary),
        ),
        if (activity.skills?.isNotEmpty == true)
          const SizedBox(
            height: 12,
          ),
        if (activity.skills?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activity.skills
                      ?.map(
                        (skill) => Chip(
                          avatar: const Icon(Icons.wb_sunny_outlined),
                          label: Text(skill.name),
                        ),
                      )
                      .toList() ??
                  <Widget>[],
            ),
          ),
      ],
    );
  }
}
