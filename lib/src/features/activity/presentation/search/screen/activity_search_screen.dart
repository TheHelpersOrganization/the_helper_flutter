import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/default_activity_view.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/search_activity_view.dart';

class ActivitySearchScreen extends ConsumerWidget {
  const ActivitySearchScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPattern = ref.watch(searchPatternProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Activities'),
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
                  ref.read(searchPatternProvider.notifier).state = value;
                  ref.read(hasUsedSearchProvider.notifier).state = true;
                },
                onClear: () {
                  ref.read(searchPatternProvider.notifier).state = '';
                  ref.read(hasUsedSearchProvider.notifier).state = true;
                }),
            const SizedBox(height: 24),
            Expanded(
              child: searchPattern == ''
                  ? const DefaultActivityView()
                  : const SearchActivityView(),
            ),
          ],
        ),
      ),
    );
  }
}
