import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/organization/presentation/my/my_organization_controller.dart';

import '../../../../common/widget/drawer/app_drawer.dart';
import '../../domain/organization.dart';
import '../search/organization_card.dart';

class MyOrganizationScreen extends ConsumerWidget {
  const MyOrganizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = ref.watch(myPagingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Organizations'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: PagedListView<int, Organization>(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) =>
                      OrganizationCard(organization: item),
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
}
