import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/organization/data/admin_organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';

import '../../../../../utils/async_value.dart';
import '../../../domain/organization_query.dart';
import '../../../domain/organization_status.dart';


class OrganizationManageScreenController
    extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}

  Future<Organization?> ban(int orgId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() =>
        ref.watch(adminOrganizationRepositoryProvider).ban(orgId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<Organization?> unban(int orgId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() =>
        ref.watch(adminOrganizationRepositoryProvider).unban(orgId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<Organization?> approve(int orgId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() =>
        ref.watch(adminOrganizationRepositoryProvider).verify(orgId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<Organization?> reject(int orgId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() =>
        ref.watch(adminOrganizationRepositoryProvider).reject(orgId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }
}

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);


final accountManageControllerProvider = AutoDisposeAsyncNotifierProvider<
    OrganizationManageScreenController, void>(
  () => OrganizationManageScreenController(),
);

class ScrollPagingControlNotifier extends PagedNotifier<int, Organization> {
  final AdminOrganizationRepository adminOrganizationRepository;
  final OrganizationStatus tabStatus;
  final String? searchPattern;

  ScrollPagingControlNotifier({
    required this.adminOrganizationRepository,
    required this.tabStatus,
    this.searchPattern,
  }) : super(
          load: (page, limit) {
            return adminOrganizationRepository.getAll(
              query: OrganizationQuery(
                limit: limit,
                offset: page * limit,
                status: tabStatus,
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final scrollPagingControlNotifier = StateNotifierProvider.autoDispose
    .family<ScrollPagingControlNotifier, PagedState<int, Organization>, OrganizationStatus>(
        (ref, index) => ScrollPagingControlNotifier(
            adminOrganizationRepository: ref.watch(adminOrganizationRepositoryProvider),
            tabStatus: index,
            searchPattern: ref.watch(searchPatternProvider)));
