import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/shift/domain/shift_skill.dart';

class ShiftSkillList extends StatelessWidget {
  final List<ShiftSkill>? skills;

  const ShiftSkillList({
    super.key,
    this.skills,
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
          height: 4,
        ),
        if (skills?.isEmpty == true)
          Text(
            'No skill required',
            style: TextStyle(color: context.theme.colorScheme.secondary),
          ),
        if (skills?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills
                      ?.map(
                        (sk) => Chip(
                          avatar: const Icon(Icons.wb_sunny_outlined),
                          label: Text(
                              '${sk.skill?.name ?? 'Unknown'} - ${sk.hours}h'),
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
