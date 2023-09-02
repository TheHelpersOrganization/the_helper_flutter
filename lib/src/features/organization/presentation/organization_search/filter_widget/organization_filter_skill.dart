import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/skill/data/skill_repository.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';
import 'package:the_helper/src/features/skill/domain/skill_query.dart';

import '../organization_filter_controller.dart';

class OrganizationFilterSkill extends ConsumerStatefulWidget {
  const OrganizationFilterSkill({super.key});

  @override
  ConsumerState<OrganizationFilterSkill> createState() =>
      _OrganizationFilterSkillState();
}

class _OrganizationFilterSkillState extends ConsumerState<OrganizationFilterSkill> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final selectedSkills = ref.watch(selectedSkillsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Skills',
          style: context.theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: selectedSkills
              .map(
                (e) => Chip(
                  label: Text(e.name),
                  deleteIcon: const Icon(
                    Icons.clear_outlined,
                    size: 20,
                  ),
                  onDeleted: () =>
                      ref.read(selectedSkillsProvider.notifier).update(
                            (state) => {
                              ...state..remove(e),
                            },
                          ),
                ),
              )
              .toList(),
        ),
        if (selectedSkills.isNotEmpty) const SizedBox(height: 12),
        FormBuilderTypeAhead<Skill>(
          enabled: selectedSkills.length < 5,
          controller: controller,
          name: 'skills',
          itemBuilder: (context, item) => ListTile(
            title: Text(item.name),
          ),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.clear_outlined),
            ),
            hintText: 'Search skills',
            helperText: 'Max 5 skills',
          ),
          suggestionsCallback: (pattern) =>
              ref.read(skillRepositoryProvider).getSkills(
                    query: SkillQuery(
                      name: pattern.trim(),
                      limit: 5,
                    ),
                  ),
          onSuggestionSelected: (suggestion) {
            ref.read(selectedSkillsProvider.notifier).update((state) => {
                  ...state..add(suggestion),
                });
            controller.clear();
          },
          selectionToTextTransformer: (suggestion) => suggestion.name,
          loadingBuilder: (_) => const ListTile(
            title: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          suggestionsBoxVerticalOffset: 12,
        ),
      ],
    );
  }
}
