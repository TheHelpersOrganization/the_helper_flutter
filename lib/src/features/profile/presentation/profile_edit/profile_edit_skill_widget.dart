import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';
import 'package:the_helper/src/features/skill/domain/skill_icon_name_map.dart';

import '../../domain/profile.dart';
import '../profile_controller.dart';
import 'add_skill_dialog_widget.dart';
import 'profile_edit_controller.dart';

class ProfileEditSkillWidget extends ConsumerWidget {
  final Profile profile;

  const ProfileEditSkillWidget({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialSkills = profile.interestedSkills;
    final skillHolderLists = ref.watch(selectedSkillsProvider);
    Set<Skill> selectedSkills = skillHolderLists ?? initialSkills.toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Interested skills',
                style: context.theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (skillHolderLists != null)
              TextButton.icon(
                onPressed: () {
                  ref.read(profileControllerProvider().notifier).updateProfile(
                      profile.copyWith(
                          interestedSkills: selectedSkills.toList()));
                },
                icon: const Icon(Icons.check),
                label: const Text('Save change'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              ActionChip(
                avatar: const Icon(Icons.add),
                label: const Text('Add skill'),
                onPressed: () {
                  showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (context) =>
                          AddSkillDialogWidget(selectedSkills: selectedSkills));
                },
              ),
              for (var i in selectedSkills)
                Chip(
                    avatar: Icon(SkillIcons[i.name]),
                    label: Text(i.name),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      selectedSkills.remove(i);
                      ref.read(selectedSkillsProvider.notifier).state = {
                        ...selectedSkills
                      };
                    }),
            ])
      ],
    );
  }
}
