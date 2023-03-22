import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization_model.dart';

class OrganizationSearchController
    extends AutoDisposeAsyncNotifier<List<OrganizationModel>> {
  @override
  FutureOr<List<OrganizationModel>> build() {
    return ref.watch(organizationRepositoryProvider).getAll();
  }
}

final organizationSearchControllerProvider = AutoDisposeAsyncNotifierProvider<
    OrganizationSearchController,
    List<OrganizationModel>>(() => OrganizationSearchController());

final searchPatternProvider = StateProvider.autoDispose((ref) => '');

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final organizationRepo = ref.watch(organizationRepositoryProvider);
    //final searchPattern = ref.watch(organizationSearchControllerProvider);

    final controller =
        PagingController<int, OrganizationModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await organizationRepo.getAll(offset: pageKey * 100);
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
    return controller;
  },
);
