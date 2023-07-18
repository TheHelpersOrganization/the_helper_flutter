import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization/data/admin_organization_repository.dart';

import '../domain/organization.dart';
import '../domain/organization_query.dart';

part 'admin_organization_service.g.dart';

class AdminOrganizationService {
  final AdminOrganizationRepository organizationRepository;

  const AdminOrganizationService({
    required this.organizationRepository,
  });

  Future<List<Organization>> getAll({
    OrganizationQuery? query,
  }) async {
    final orgs = await organizationRepository.getAll(query: query);
    return orgs;
  }

  Future<int> getCount({
    OrganizationQuery? query,
  }) async {
    final orgs = await organizationRepository.getAll(query: query);
    return orgs.length;
  }

  Future<int> getRequestCount({
    OrganizationQuery? query,
  }) async {
    // final List<dynamic> res = (await client.get(
    //   '/organizations',
    //   queryParameters: query?.toJson(),
    // ))
    //     .data['data'];
    // return res.map((e) => Organization.fromJson(e)).toList().length;
    return 5;
  }
}

@riverpod
AdminOrganizationService adminOrganizationService(AdminOrganizationServiceRef ref) {
  return AdminOrganizationService(
    organizationRepository: ref.watch(adminOrganizationRepositoryProvider),
  );
}
