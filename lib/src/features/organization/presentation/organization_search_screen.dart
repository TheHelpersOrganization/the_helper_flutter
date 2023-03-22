import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';

import 'organization_widget.dart';

class OrganizationSearchScreen extends ConsumerWidget {
  const OrganizationSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onDebounce: (value) {},
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView(
                children: const [
                  OrganizationCard(),
                  OrganizationCard(),
                  OrganizationCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
