import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_filter_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_filter/activity_filter_date_range.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_filter/activity_filter_location.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_filter/activity_filter_organization.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_filter/activity_filter_skill.dart';

final formKey = GlobalKey<FormBuilderState>();

class ActivityFilterDrawer extends ConsumerWidget {
  const ActivityFilterDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMarkedToReset = ref.watch(isMarkedToResetProvider);

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Activity Filter',
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const ActivityFilterSkill(),
                    const SizedBox(height: 24),
                    const ActivityFilterOrganization(),
                    const SizedBox(height: 24),
                    const ActivityFilterDateRange(),
                    const SizedBox(height: 24),
                    const ActivityFilterLocation(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              titleText: 'Reset filter',
                              content: const Text(
                                'Are you sure you want to reset the filter?',
                              ),
                              onConfirm: () {
                                ref.invalidate(activityQueryProvider);
                                context.pop();
                                context.pop();
                              },
                            ),
                          );
                        },
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: () {
                          if (formKey.currentState?.saveAndValidate() != true) {
                            return;
                          }
                          // if (isMarkedToReset) {
                          //   ref.read(isMarkedToResetProvider.notifier).state =
                          //       false;
                          //   ref.read(activityQueryProvider.notifier).state =
                          //       null;
                          //   context.pop();
                          //   return;
                          // }
                          final selectedSkills =
                              ref.read(selectedSkillsProvider);
                          final selectedOrganizations =
                              ref.read(selectedOrganizationsProvider);
                          final selectedStartTime =
                              ref.read(selectedStartTimeProvider);
                          final selectedEndTime =
                              ref.read(selectedEndTimeProvider);
                          final selectedLocation =
                              ref.read(selectedLocationProvider);
                          final place = ref.read(placeProvider);

                          ref.read(activityQueryProvider.notifier).state =
                              ActivityQuery(
                            skill: selectedSkills.isNotEmpty
                                ? ref
                                    .read(selectedSkillsProvider)
                                    .map((e) => e.id)
                                    .toList()
                                : null,
                            org: selectedOrganizations.isNotEmpty
                                ? ref
                                    .read(selectedOrganizationsProvider)
                                    .map((e) => e.id)
                                    .toList()
                                : null,
                            startTime: selectedStartTime != null
                                ? [selectedStartTime]
                                : null,
                            endTime: selectedEndTime != null
                                ? [null, selectedEndTime]
                                : null,
                            locality:
                                selectedLocation?.type == LocationType.locality
                                    ? selectedLocation!.value
                                    : null,
                            region:
                                selectedLocation?.type == LocationType.region
                                    ? selectedLocation!.value
                                    : null,
                            country:
                                selectedLocation?.type == LocationType.country
                                    ? selectedLocation!.value
                                    : null,
                            lat: place?.latitude,
                            lng: place?.longitude,
                            radius: ref
                                    .read(radiusTextEditingControllerProvider)
                                    .text
                                    .isNotEmpty
                                ? double.tryParse(ref
                                    .read(radiusTextEditingControllerProvider)
                                    .text)
                                : null,
                          );
                          context.pop();
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
