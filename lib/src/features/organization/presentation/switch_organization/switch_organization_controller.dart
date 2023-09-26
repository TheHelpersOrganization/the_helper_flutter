import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/role_controller.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';
import 'package:the_helper/src/features/organization/data/current_organization_repository.dart';
import 'package:the_helper/src/features/organization/data/mod_organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/utils/async_value.dart';

final selectedOrganization = StateProvider.autoDispose<int?>((ref) => null);

// final currentOrganizationProvider = FutureProvider.autoDispose((ref) =>
//     ref.watch(currentOrganizationRepositoryProvider).getCurrentOrganization());

final joinedOrganizationProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(modOrganizationRepositoryProvider).getOwnedOrganizations(),
);

class SwitchOrganizationController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() async {
    await ref.watch(currentOrganizationServiceProvider.future);
  }

  Future<Organization?> switchOrganization(int organizationId) async {
    final res = await guardAsyncValue(() => ref
        .read(currentOrganizationServiceProvider.notifier)
        .setCurrentOrganization(organizationId));
    ref
        .read(setRoleControllerProvider.notifier)
        .setCurrentRole(Role.moderator, navigateToHome: true);
    ref.invalidate(currentOrganizationRepositoryProvider);
    return res.valueOrNull;
  }
}

final switchOrganizationControllerProvider =
    AutoDisposeAsyncNotifierProvider<SwitchOrganizationController, void>(
  () => SwitchOrganizationController(),
);
