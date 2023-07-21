import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization/data/admin_organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization_status.dart';

import '../domain/admin_organization.dart';
import '../domain/admin_organization_query.dart';

part 'admin_organization_service.g.dart';

class AdminOrganizationService {
  final AdminOrganizationRepository organizationRepository;

  const AdminOrganizationService({
    required this.organizationRepository,
  });

  Future<List<AdminOrganization>> getAll({
    AdminOrganizationQuery? query,
  }) async {
    final orgs = await organizationRepository.getAll(query: query);
    return orgs;
  }

  Future<int> getCount({
    AdminOrganizationQuery? query,
  }) async {
    final orgs = await organizationRepository.getAll(
      query: const AdminOrganizationQuery(status: OrganizationStatus.verified));
    return orgs.length;
  }

  Future<int> getRequestCount({
    AdminOrganizationQuery? query,
  }) async {
    final orgs = await organizationRepository.getAll(
      query: const AdminOrganizationQuery(status: OrganizationStatus.pending));
    return orgs.length;
  }
}

@riverpod
AdminOrganizationService adminOrganizationService(AdminOrganizationServiceRef ref) {
  return AdminOrganizationService(
    organizationRepository: ref.watch(adminOrganizationRepositoryProvider),
  );
}
