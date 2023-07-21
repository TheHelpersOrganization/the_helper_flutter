import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/organization/data/admin_organization_repository.dart';

import '../../../../../utils/async_value.dart';
import '../../../domain/admin_organization.dart';
import '../../../domain/admin_organization_query.dart';
import '../../../domain/organization_status.dart';

class OrganizationManageScreenController
    extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}

  Future<AdminOrganization?> ban(int orgId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(
        () => ref.watch(adminOrganizationRepositoryProvider).ban(orgId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<AdminOrganization?> unban(int orgId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(
        () => ref.watch(adminOrganizationRepositoryProvider).unban(orgId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<AdminOrganization?> approve(int orgId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(
        () => ref.watch(adminOrganizationRepositoryProvider).verify(orgId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<AdminOrganization?> reject(int orgId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(
        () => ref.watch(adminOrganizationRepositoryProvider).reject(orgId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }
}

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);

final organizatonManageControllerProvider =
    AutoDisposeAsyncNotifierProvider<OrganizationManageScreenController, void>(
  () => OrganizationManageScreenController(),
);

class RequestScrollPagingControlNotifier
    extends PagedNotifier<int, AdminOrganization> {
  final AdminOrganizationRepository adminOrganizationRepository;
  final OrganizationStatus tabStatus;
  final String? searchPattern;

  RequestScrollPagingControlNotifier({
    required this.adminOrganizationRepository,
    required this.tabStatus,
    this.searchPattern,
  }) : super(
          load: (page, limit) {
            return adminOrganizationRepository.getAll(
              query: AdminOrganizationQuery(
                limit: limit,
                offset: page * limit,
                status: tabStatus,
                include: 'file',
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final requestScrollPagingControlNotifier = StateNotifierProvider.autoDispose
    .family<RequestScrollPagingControlNotifier,
            PagedState<int, AdminOrganization>, OrganizationStatus>(
        (ref, index) => RequestScrollPagingControlNotifier(
            adminOrganizationRepository:
                ref.watch(adminOrganizationRepositoryProvider),
            tabStatus: index,
            searchPattern: ref.watch(searchPatternProvider)));

class ScrollPagingControlNotifier
    extends PagedNotifier<int, AdminOrganization> {
  final AdminOrganizationRepository adminOrganizationRepository;
  final bool tabStatus;
  final String? searchPattern;

  ScrollPagingControlNotifier({
    required this.adminOrganizationRepository,
    required this.tabStatus,
    this.searchPattern,
  }) : super(
          load: (page, limit) {
            return adminOrganizationRepository.getAll(
              query: AdminOrganizationQuery(
                  limit: limit,
                  offset: page * limit,
                  status: OrganizationStatus.verified,
                  isDisabled: tabStatus),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final scrollPagingControlNotifier = StateNotifierProvider.autoDispose.family<
        ScrollPagingControlNotifier, PagedState<int, AdminOrganization>, bool>(
    (ref, index) => ScrollPagingControlNotifier(
        adminOrganizationRepository:
            ref.watch(adminOrganizationRepositoryProvider),
        tabStatus: index,
        searchPattern: ref.watch(searchPatternProvider)));
