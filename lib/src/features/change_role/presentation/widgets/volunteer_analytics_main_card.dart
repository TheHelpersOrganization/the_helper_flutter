import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/skill/domain/skill_icon_dir.dart';

import '../../../skill/domain/skill.dart';

class VolunteerAnalyticsMainCard extends StatelessWidget {
  final List<Skill> skillList;
  const VolunteerAnalyticsMainCard({
    super.key,
    required this.skillList,
  });

  @override
  Widget build(BuildContext context) {
    final onPrimaryColor = context.theme.colorScheme.onPrimary;

    List<Skill> sortedList = List.from(skillList);
    sortedList.sort((b, a) => (a.hours ?? 0.0).compareTo(b.hours ?? 0.0));
    final topSkills = sortedList.sublist(0, min(3, sortedList.length));
    return Card(
      color: context.theme.primaryColor,
      margin: const EdgeInsets.only(right: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: onPrimaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Top skills',
                  style: TextStyle(color: onPrimaryColor),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 0,
                indent: 0,
              ),
            ),
            // for(var i in skillList)
            // Row(
            //   children: [
            //     Chip(
            //       avatar: Icon(skillIcons[i.name]),
            //       label: Text(i.name),
            //       elevation: 1,
            //     ),
            //     Text(
            //       (i.hours ?? 0).toString(),
            //       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            //         color: onPrimaryColor,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Chip(
                  avatar: Icon(Icons.medical_services_outlined),
                  label: Text('Healthcare'),
                  elevation: 1,
                ),
                Text(
                  '15 H',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: onPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Chip(
                  avatar: Icon(Icons.medical_services_outlined),
                  label: Text('Healthcare'),
                  elevation: 1,
                ),
                Text(
                  '15',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: onPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
