import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/data/current_organization_repository.dart';
import 'package:the_helper/src/features/organization/data/mod_organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/utils/async_value.dart';

class CurrentOrganizationService extends AsyncNotifier<Organization?> {
  @override
  FutureOr<Organization?> build() async {
    final id = await ref
        .watch(currentOrganizationRepositoryProvider)
        .getCurrentOrganizationId();
    if (id == null) {
      return null;
    }
    return ref
        .watch(modOrganizationRepositoryProvider)
        .getOwnedOrganizationById(id);
  }

  Future<int?> getCurrentOrganizationId() async {
    if (state.hasValue) {
      return state.value!.id;
    }
    return ref
        .watch(currentOrganizationRepositoryProvider)
        .getCurrentOrganizationId();
  }

  Future<Organization?> setCurrentOrganization(int organizationId) async {
    state = const AsyncValue.loading();
    state = await guardAsyncValue(() => ref
        .watch(currentOrganizationRepositoryProvider)
        .setCurrentOrganization(organizationId));
    return state.valueOrNull;
  }
}

final currentOrganizationServiceProvider =
    AsyncNotifierProvider<CurrentOrganizationService, Organization?>(
  () => CurrentOrganizationService(),
);
