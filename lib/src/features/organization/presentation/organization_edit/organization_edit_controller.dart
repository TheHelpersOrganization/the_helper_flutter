import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';

import '../../domain/organization.dart';

class OrganizationEditController
    extends AutoDisposeFamilyAsyncNotifier<Organization?, int> {
  @override
  FutureOr<Organization?> build(int arg) async {
    final org = await ref.watch(organizationRepositoryProvider).getById(arg);
    return org;
  }
}

final organizationEditControllerProvider =
    AutoDisposeAsyncNotifierProviderFamily<OrganizationEditController,
        Organization?, int>(() => OrganizationEditController());
