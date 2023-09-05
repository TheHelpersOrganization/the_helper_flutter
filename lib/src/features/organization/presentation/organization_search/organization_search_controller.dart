
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';

import '../../domain/organization.dart';
import '../../domain/organization_query.dart';
import 'organization_filter_controller.dart';

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final hasUsedSearchProvider = StateProvider.autoDispose((ref) => false);

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
            final q = query ?? const OrganizationQuery();
            return organizationRepo.getAll(
              query: q.copyWith(
                limit: limit,
                offset: page*limit,
                name: searchPattern,
                joined: false
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
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
