import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/data/current_organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/utils/async_value.dart';

final selectedOrganization = StateProvider.autoDispose<int?>((ref) => null);

final currentOrganizationProvider = FutureProvider.autoDispose((ref) =>
    ref.watch(currentOrganizationRepositoryProvider).getCurrentOrganization());

class SwitchOrganizationController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    ref.watch(currentOrganizationRepositoryProvider);
  }

  Future<Organization?> switchOrganization(int organizationId) async {
    //state = const AsyncLoading();
    final res = await guardAsyncValue(() => ref
        .read(currentOrganizationRepositoryProvider)
        .setCurrentOrganization(organizationId));
    //state = res;
    return res.valueOrNull;
  }
}

final switchOrganizationControllerProvider =
    AutoDisposeAsyncNotifierProvider<SwitchOrganizationController, void>(
  () => SwitchOrganizationController(),
);
