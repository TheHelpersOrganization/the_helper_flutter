import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/domain/data_log.dart';

import 'package:the_helper/src/features/activity/domain/activity_log_query.dart';
import 'package:the_helper/src/features/organization/data/admin_organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization_status.dart';

import '../domain/admin_organization.dart';
import '../domain/admin_organization_query.dart';

import '../domain/organization_log_query.dart';

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

  Future<AdminOrganization> getById(int id) async {
    final orgs = await organizationRepository.getById(id);
    return orgs;
  }

  Future<DataLog> getLog({
    OrganizationLogQuery? query,
  }) async {
    DataLog log = await organizationRepository.getLog(query: query);
    return log;
  }
}

@riverpod
AdminOrganizationService adminOrganizationService(
    AdminOrganizationServiceRef ref) {
  return AdminOrganizationService(
    organizationRepository: ref.watch(adminOrganizationRepositoryProvider),
  );
}

@riverpod
Future<AdminOrganization> getOrganization(
  GetOrganizationRef ref,
  int orgId,
) =>
    ref.watch(adminOrganizationServiceProvider).getById(orgId);
