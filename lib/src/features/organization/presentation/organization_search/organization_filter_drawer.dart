import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';


import '../../domain/organization_query.dart';
import 'filter_widget/organization_filter_location.dart';
import 'filter_widget/organization_filter_skill.dart';
import 'organization_filter_controller.dart';

final formKey = GlobalKey<FormBuilderState>();

class OrganizationFilterDrawer extends ConsumerWidget {
  const OrganizationFilterDrawer({super.key});

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
                            'Organization Filter',
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
                    const OrganizationFilterSkill(),
                    const SizedBox(height: 24),
                    const OrganizationFilterLocation(),
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
                          ref.invalidate(selectedSkillsProvider);
                          ref.invalidate(radiusTextEditingControllerProvider);
                          ref.invalidate(isLocationFilterSimpleModeProvider);
                          ref.invalidate(placeProvider);
                          ref.invalidate(selectedLocationProvider);
                          ref.read(isMarkedToResetProvider.notifier).state =
                              true;
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
                          if (isMarkedToReset) {
                            ref.read(isMarkedToResetProvider.notifier).state =
                                false;
                            ref.read(organizationQueryProvider.notifier).state =
                                null;
                            context.pop();
                            return;
                          }
                          final selectedSkills =
                              ref.read(selectedSkillsProvider);
                          final selectedLocation =
                              ref.read(selectedLocationProvider);
                          final place = ref.read(placeProvider);

                          ref.read(organizationQueryProvider.notifier).state =
                              OrganizationQuery(
                            skill: selectedSkills.isNotEmpty
                                ? ref
                                    .read(selectedSkillsProvider)
                                    .map((e) => e.id)
                                    .toList()
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
