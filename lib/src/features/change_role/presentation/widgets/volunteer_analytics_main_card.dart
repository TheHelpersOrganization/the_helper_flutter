import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/skill/domain/skill_icon_dir.dart';

import '../../../skill/domain/skill.dart';
import 'skill_list_item.dart';

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
    final topSkills = sortedList.sublist(0, min(4, sortedList.length));
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
            Expanded(
              child: topSkills.isEmpty
              ? Center(
                child: Text(
                  'You don\'t have any skill to show yet.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: onPrimaryColor,
                    // fontWeight: FontWeight.w500,
                  ),
                )
              )
              : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for(var i in topSkills)
                SkillListItem(
                  name: i.name, 
                  icon: skillIcons[i.name]!, 
                  hour: i.hours!, 
                  color: onPrimaryColor
                ),
            ],
            )),
            
          ],
        ),
      ),
    );
  }
}
