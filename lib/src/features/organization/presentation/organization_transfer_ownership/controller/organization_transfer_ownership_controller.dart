import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/domain/organization_transfer_ownership.dart';
import 'package:the_helper/src/features/organization_member/data/mod_organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/data/organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/get_organization_member_query.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member_status.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

class OrganizationTransferOwnershipData {
  final Organization currentOrganization;
  final OrganizationMember myMember;

  OrganizationTransferOwnershipData({
    required this.currentOrganization,
    required this.myMember,
  });
}

final organizationTransferOwnershipDataProvider = FutureProvider.autoDispose(
  (ref) async {
    final organization =
        await ref.watch(currentOrganizationServiceProvider.future);
    final myMember = ref.watch(organizationMemberRepositoryProvider).getMe(
          organizationId: organization!.id,
        );

    return OrganizationTransferOwnershipData(
      currentOrganization: organization,
      myMember: await myMember,
    );
  },
);

final passwordControllerProvider =
    ChangeNotifierProvider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

final selectedMemberProvider = StateProvider.autoDispose<OrganizationMember?>(
  (ref) => null,
);
final membersProvider = FutureProvider.autoDispose(
  (ref) async {
    final organization =
        await ref.watch(currentOrganizationServiceProvider.future);
    return ref
        .watch(modOrganizationMemberRepositoryProvider)
        .getMemberWithAccountProfile(
          organization!.id,
          query: GetOrganizationMemberQuery(
            statuses: [OrganizationMemberStatus.approved],
          ),
        );
  },
);

class OrganizationTransferOwnershipController
    extends AutoDisposeAsyncNotifier<void> {
  late Object? _key;

  @override
  FutureOr<void> build() {
    _key = Object();
    ref.onDispose(() {
      ref.onDispose(() => _key = null);
    });
  }

  Future<void> transferOwnership({
    required int organizationId,
    required OrganizationTransferOwnership data,
  }) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncLoading();

    final key = _key;
    final res = await guardAsyncValue(
      () => ref.watch(organizationRepositoryProvider).transferOwnership(
            organizationId: organizationId,
            data: data,
          ),
    );

    if (key != _key) {
      return;
    }

    if (res.hasError) {
      state = AsyncValue.error(res.asError!.error, res.stackTrace!);
      return;
    }

    ref
        .watch(routerProvider)
        .goNamed(AppRoute.organizationTransferOwnershipSuccess.name);

    state = const AsyncValue.data(null);
  }
}

final organizationTransferOwnershipControllerProvider =
    AutoDisposeAsyncNotifierProvider<OrganizationTransferOwnershipController,
        void>(
  () => OrganizationTransferOwnershipController(),
);
