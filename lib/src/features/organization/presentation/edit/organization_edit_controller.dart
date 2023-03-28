import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization_model.dart';

class OrganizationEditController
    extends AutoDisposeFamilyAsyncNotifier<OrganizationModel, int> {
  @override
  FutureOr<OrganizationModel> build(int arg) async {
    final org = await ref.watch(organizationRepositoryProvider).getById(arg);
    return org;
  }
}

final organizationEditControllerProvider =
    AutoDisposeAsyncNotifierProviderFamily<OrganizationEditController,
        OrganizationModel, int>(() => OrganizationEditController());
