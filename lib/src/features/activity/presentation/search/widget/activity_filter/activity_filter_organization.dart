import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_filter_controller.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/domain/organization_query.dart';
import 'package:the_helper/src/utils/image.dart';

class ActivityFilterOrganization extends ConsumerStatefulWidget {
  const ActivityFilterOrganization({super.key});

  @override
  ConsumerState<ActivityFilterOrganization> createState() =>
      _ActivityFilterOrganizationState();
}

class _ActivityFilterOrganizationState
    extends ConsumerState<ActivityFilterOrganization> {
  // Auto-dispose by typeahead widget
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final selectedOrganizations = ref.watch(selectedOrganizationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Organization',
          style: context.theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: selectedOrganizations
              .map(
                (e) => Chip(
                  avatar: CircleAvatar(
                    backgroundImage: getBackendImageOrLogoProvider(e.logo),
                  ),
                  label: Text(e.name),
                  deleteIcon: const Icon(
                    Icons.clear_outlined,
                    size: 20,
                  ),
                  onDeleted: () =>
                      ref.read(selectedOrganizationsProvider.notifier).update(
                            (state) => {
                              ...state..remove(e),
                            },
                          ),
                ),
              )
              .toList(),
        ),
        if (selectedOrganizations.isNotEmpty) const SizedBox(height: 12),
        FormBuilderTypeAhead<Organization>(
          controller: controller,
          name: 'organizations',
          itemBuilder: (context, item) => ListTile(
            leading: CircleAvatar(
              backgroundImage: getBackendImageOrLogoProvider(item.logo),
              radius: 16,
            ),
            title: Text(item.name),
          ),
          enabled: selectedOrganizations.length < 5,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.clear_outlined),
            ),
            hintText: 'Search organizations',
            helperText: 'Max 5 organizations',
          ),
          suggestionsCallback: (pattern) =>
              ref.read(organizationRepositoryProvider).getAll(
                    query: OrganizationQuery(
                      name: pattern.trim(),
                      limit: 5,
                    ),
                  ),
          onSuggestionSelected: (suggestion) {
            ref.read(selectedOrganizationsProvider.notifier).update((state) => {
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
