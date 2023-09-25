import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/utils/paging.dart';

import '../../../domain/organization.dart';
import '../../../domain/organization_query.dart';
import 'organization_filter_controller.dart';

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final hasUsedSearchProvider = StateProvider.autoDispose((ref) => false);
final searchControllerProvider = ChangeNotifierProvider.autoDispose(
  (ref) => TextEditingController(),
);

class OrganizationListPagedNotifier extends PagedNotifier<int, Organization> {
  final OrganizationRepository organizationRepo;
  final String? searchPattern;
  final OrganizationQuery? query;

  OrganizationListPagedNotifier({
    required this.organizationRepo,
    this.searchPattern,
    required this.query,
  }) : super(
          load: (page, limit) {
            int? cursor = page == 0 ? null : page;
            final q = query ?? const OrganizationQuery();
            return organizationRepo.getAll(
              query: q.copyWith(
                limit: limit,
                cursor: cursor,
                name: searchPattern,
                joined: false,
                include: [OrganizationInclude.numberOfActivities],
              ),
            );
          },
          nextPageKeyBuilder: cursorBasedPaginationNextKeyBuilder,
          printStackTrace: true,
        );
}

final organizationListPagedNotifierProvider = StateNotifierProvider.autoDispose<
    OrganizationListPagedNotifier, PagedState<int, Organization>>(
  (ref) {
    final organizationRepo = ref.watch(organizationRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final query = ref.watch(organizationQueryProvider);
    return OrganizationListPagedNotifier(
      organizationRepo: organizationRepo,
      searchPattern: searchPattern,
      query: query,
    );
  },
);
