import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';

import '../../../organization_member/domain/organization_member_status.dart';
import '../../domain/organization.dart';
import '../../domain/organization_query.dart';

final myPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final organizationRepo = ref.watch(organizationRepositoryProvider);
    final controller = PagingController<int, Organization>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await organizationRepo.get(
          offset: pageKey * 100,
          query: const OrganizationQuery(
            memberStatus: OrganizationMemberStatus.approved,
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
    return controller;
  },
);
