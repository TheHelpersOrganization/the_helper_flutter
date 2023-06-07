import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/shift/domain/shift_skill.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';

final _formKey = GlobalKey<FormBuilderState>();

class ShiftSkillView extends ConsumerWidget {
  final List<Skill> skills;

  const ShiftSkillView({
    super.key,
    required this.skills,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSkills = ref.watch(selectedSkillsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Skill'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              if (_formKey.currentState?.saveAndValidate() != true) {
                return;
              }
              final formData = _formKey.currentState!.value;

              final skill = formData['skill'];

              if (selectedSkills
                  .any((element) => element.skill!.id == skill.id)) {
                final shouldReplace = await showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (_) => AlertDialog(
                    title: const Text('Skill already added'),
                    content: const Text('Do you want to replace the old one?'),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => context.pop(true),
                        child: const Text('Replace'),
                      ),
                    ],
                  ),
                );
                if (!shouldReplace) {
                  return;
                }
              }

              if (!context.mounted) {
                return;
              }

              final time = formData['hours'];
              final unit = formData['unit'];
              final hours = unit == 'days' ? time * 24 : time;

              selectedSkills
                  .removeWhere((element) => element.skill!.id == skill.id);

              ref.read(selectedSkillsProvider.notifier).state = [
                ...selectedSkills,
                ShiftSkill(
                  skill: skill,
                  hours: hours,
                )
              ];

              context.pop();
            },
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderSearchableDropdown<Skill>(
                name: 'skill',
                items: skills,
                itemAsString: (item) => item.name,
                compareFn: (item1, item2) => item1.id == item2.id,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Skill'),
                  hintText: 'Search and choose skill from list',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                dropdownSearchTextStyle: context.theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: FormBuilderTextField(
                      name: 'hours',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Hours/days of experience',
                        labelText: 'Experience Time',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.min(0, inclusive: false),
                      ]),
                      valueTransformer: (value) => int.tryParse(value ?? ''),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: FormBuilderDropdown(
                      name: 'unit',
                      items: const [
                        DropdownMenuItem(
                          value: 'hours',
                          child: Text('Hours'),
                        ),
                        DropdownMenuItem(
                          value: 'days',
                          child: Text('Days'),
                        ),
                      ],
                      initialValue: 'hours',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Unit',
                        labelText: 'Unit',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
