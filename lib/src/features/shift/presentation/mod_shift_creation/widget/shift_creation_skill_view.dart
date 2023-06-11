import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_skill_view.dart';

class ShiftCreationSkillView extends ConsumerWidget {
  final int activityId;
  final Shift? initialShift;

  const ShiftCreationSkillView({
    super.key,
    required this.activityId,
    this.initialShift,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSkills =
        ref.watch(selectedSkillsProvider) ?? initialShift?.shiftSkills;
    final getSkillsState = ref.watch(getSkillsProvider);

    return getSkillsState.when(
      skipLoadingOnRefresh: false,
      error: (_, __) => CustomErrorWidget(
        onRetry: () => ref.invalidate(getSkillsProvider),
      ),
      loading: () => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 48),
          CircularProgressIndicator(),
        ],
      ),
      data: (data) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Skill Requirements',
                  style: context.theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (_) => ShiftSkillView(
                      skills: data,
                      initialSkills: initialShift?.shiftSkills,
                    ),
                    useRootNavigator: false,
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Skill'),
              ),
            ],
          ),
          if (selectedSkills?.isNotEmpty != true) ...[
            const SizedBox(height: 16),
            Text(
              'No skill added',
              style: context.theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "+ Add Skill" to add skill or skip this step',
              style: TextStyle(color: context.theme.colorScheme.secondary),
            ),
          ],
          const SizedBox(
            height: 8,
          ),
          ...ListTile.divideTiles(
            tiles: selectedSkills?.map((e) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(e.skill!.name),
                    subtitle: Text('${e.hours} hours'),
                    trailing: IconButton(
                      onPressed: () {
                        ref.read(selectedSkillsProvider.notifier).state =
                            selectedSkills
                                .where((element) => element != e)
                                .toList();
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  );
                }) ??
                [],
            context: context,
          ),
        ],
      ),
    );
  }
}
