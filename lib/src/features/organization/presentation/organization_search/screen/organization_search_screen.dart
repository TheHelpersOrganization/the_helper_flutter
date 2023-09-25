import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/common/widget/snack_bar.dart';
import 'package:the_helper/src/features/organization/presentation/organization_search/widget/organization_list_widget.dart';

import '../controller/organization_filter_controller.dart';
import '../controller/organization_join_controller.dart';
import '../controller/organization_search_controller.dart';
import '../widget/organization_filter_drawer.dart';

class OrganizationSearchScreen extends ConsumerWidget {
  const OrganizationSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPattern = ref.watch(searchPatternProvider);
    final searchController = ref.watch(searchControllerProvider);
    final organizationQuery = ref.watch(organizationQueryProvider);
    final sp =
        (searchPattern?.isNotEmpty == true) ? ' for "$searchPattern"' : '';
    final wq = organizationQuery != null ? ' with applied filter' : '';

    ref.listen<AsyncValue<void>>(
      organizationJoinControllerProvider,
      (_, state) => state.whenOrNull(
        error: (error, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackBarFromException(error),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Organization'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.filter_list_outlined),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                DebounceSearchBar(
                  controller: searchController,
                  debounceDuration: const Duration(seconds: 1),
                  hintText: 'Search organizations',
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
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      endDrawer: const OrganizationFilterDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (searchPattern?.isNotEmpty == true ||
                organizationQuery != null) ...[
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Search results$sp$wq',
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(searchPatternProvider.notifier).state = '';
                      ref.invalidate(organizationQueryProvider);
                      searchController.clear();
                    },
                    child: const Text(
                      'Clear filter',
                    ),
                  ),
                ],
              ),
            ] else
              const SizedBox(
                height: 12,
              ),
            Expanded(
              child: OrganizationListWidget(
                organizationQuery: organizationQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
