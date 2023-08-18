import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/profile/presentation/profile_edit/profile_edit_controller.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';
import 'package:the_helper/src/features/skill/domain/skill_icon_name_map.dart';

class AddSkillDialogWidget extends ConsumerWidget {
  final Set<Skill> selectedSkills;

  const AddSkillDialogWidget({super.key, required this.selectedSkills});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillList = ref.watch(skillEditControllerProvider);

    return AlertDialog(
      title: Column(
        children: [
          Text(
            'Choose a skill',
            style: context.theme.textTheme.titleLarge,
          ),
          const SizedBox(
            height: 15,
          ),
          DebounceSearchBar(
            hintText: 'Search skill',
            debounceDuration: const Duration(seconds: 1),
            small: true,
            onDebounce: (value) {
              ref.read(searchPatternProvider.notifier).state =
                  value.trim().isNotEmpty ? value.trim() : null;
            },
            onClear: () {
              ref.read(searchPatternProvider.notifier).state = null;
            },
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: skillList.when(
              error: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'An error has happened',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (data) => SingleChildScrollView(
                child: Column(
                  children: data.map((e) {
                    final bool isSelected = selectedSkills.contains(e);
                    return ListTile(
                      leading: Icon(SkillIcons[e.name]),
                      title: Text(e.name),
                      subtitle: isSelected ? const Text('Already added') : null,
                      onTap: () {
                        selectedSkills.add(e);
                        ref.read(selectedSkillsProvider.notifier).state = {
                          ...selectedSkills
                        };
                        context.pop();
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
