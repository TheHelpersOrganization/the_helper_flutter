import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/features/shift/domain/shift_skill.dart';

class ShiftCardSkills extends StatelessWidget {
  final List<ShiftSkill> skills;

  const ShiftCardSkills({
    super.key,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    final showedSkills = skills.take(2);
    final remainingSkills = skills.length - showedSkills.length;

    return Row(
      children: [
        ...showedSkills.map(
          (skill) => Chip(
            avatar: const Icon(Icons.wb_sunny_outlined, size: 20),
            label: Text(skill.skill!.name),
            labelPadding: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        if (remainingSkills > 0)
          Chip(
            label: Text(
              '+ $remainingSkills more',
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
      ].sizedBoxSpacing(
        const SizedBox(width: 4),
      ),
    );
  }
}
