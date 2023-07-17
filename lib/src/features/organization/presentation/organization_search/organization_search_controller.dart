import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';

import '../../domain/organization.dart';
import '../../domain/organization_query.dart';

class OrganizationSearchController
    extends AutoDisposeAsyncNotifier<List<Organization>> {
  @override
  FutureOr<List<Organization>> build() {
    return ref.watch(organizationRepositoryProvider).getAll();
  }
}

final organizationSearchControllerProvider = AutoDisposeAsyncNotifierProvider<
    OrganizationSearchController,
    List<Organization>>(() => OrganizationSearchController());

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final hasUsedSearchProvider = StateProvider.autoDispose((ref) => false);

final firstLoadPagingController = StateProvider((ref) => true);
final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final organizationRepo = ref.watch(organizationRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);
    final controller = PagingController<int, Organization>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await organizationRepo.getAll(
          query: OrganizationQuery(
            offset: pageKey * 100,
            name: searchPattern,
            joined: false,
          ),
        );
        final isLastPage = items.length < 100;
        if (isLastPage) {
          controller.appendLastPage(items);
        } else {
          controller.appendPage(items, pageKey + 1);
        }
      } catch (err) {
        controller.error = err;
      }
    });
    // Controller do not refresh when input search pattern
    if (hasUsedSearch) {
      controller.notifyPageRequestListeners(0);
    }
    return controller;
  },
);
