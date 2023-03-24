import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/organization/domain/organization_model.dart';
import 'package:the_helper/src/features/organization/presentation/organization_search_controller.dart';

import 'organization_card.dart';

class OrganizationSearchScreen extends ConsumerWidget {
  const OrganizationSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPattern = ref.watch(searchPatternProvider);
    final pagingController = ref.watch(pagingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Organization'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DebounceSearchBar(
              debounceDuration: const Duration(seconds: 1),
              onDebounce: (value) {
                if (value.trim().isEmpty) {
                  ref.read(searchPatternProvider.notifier).state = null;
                } else {
                  ref.read(searchPatternProvider.notifier).state = value;
                }
                ref.read(hasUsedSearchProvider.notifier).state = true;
              },
              onClear: () {
                ref.read(searchPatternProvider.notifier).state = null;
                ref.read(hasUsedSearchProvider.notifier).state = true;
              },
              filter: _buildFilter(context),
            ),
            const SizedBox(
              height: 16,
            ),
            if (searchPattern != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    child: Text(
                      'Search result for "$searchPattern"',
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            else
              const SizedBox(
                height: 24,
              ),
            Expanded(
              child: PagedListView<int, OrganizationModel>(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) =>
                      OrganizationCard(organizationModel: item),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        Text(
                          'No Organizations was found',
                          style: context.theme.textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Please try other search terms',
                          style: context.theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          _buildActivityTypeFilter(),
          const Divider(),
          _builderMemberFilter(context),
          const Divider(),
        ],
      ),
    );
  }

  Widget _builderMemberFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: const [
            Icon(
              Icons.person_outline_rounded,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Members',
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            const Text(
              'From',
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 16),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            const Text(
              'To',
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildActivityTypeFilter() {
    return Column(
      children: [
        Row(
          children: const [
            Icon(
              Icons.work_outline_rounded,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Activity Type',
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        FormBuilderFilterChip(
          name: 'activityType',
          spacing: 12,
          runSpacing: 12,
          decoration: const InputDecoration(border: InputBorder.none),
          options: const [
            FormBuilderChipOption(
              value: 'a',
              child: Text('a'),
            ),
            FormBuilderChipOption(
              value: 'b',
              child: Text('b'),
            ),
            FormBuilderChipOption(
              value: 'c',
              child: Text('b'),
            ),
            FormBuilderChipOption(
              value: 'd',
              child: Text('b'),
            ),
            FormBuilderChipOption(
              value: 'e',
              child: Text('b'),
            ),
            FormBuilderChipOption(
              value: 'f',
              child: Text('b'),
            ),
          ],
        )
      ],
    );
  }
}
