import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/dio.dart';
import '../domain/organization.dart';
import '../domain/organization_query.dart';
import '../domain/organization_request_model.dart';

part 'mod_organization_repository.g.dart';

class ModOrganizationRepository {
  final Dio client;

  ModOrganizationRepository({required this.client});

  Future<List<Organization>> getOwnedOrganizations({
    OrganizationQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/mod/organizations/me',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => Organization.fromJson(e)).toList();
  }

  Future<Organization?> getOwnedOrganizationById(int id) async {
    final res = await client.get('/mod/organizations/$id');
    if (res.data['data'] == null) {
      return null;
    }
    return Organization.fromJson(res.data['data']);
  }

  Future<Organization> create(OrganizationRequestModel organization) async {
    final res =
        await client.post('/organizations', data: organization.toJson());
    return Organization.fromJson(res.data['data']);
  }

  Future<void> update(int id, Organization organization) async {
    await client.put('/organization/$id', data: organization.toJson());
  }
}

@Riverpod(keepAlive: true)
ModOrganizationRepository modOrganizationRepository(
        ModOrganizationRepositoryRef ref) =>
    ModOrganizationRepository(client: ref.watch(dioProvider));

@riverpod
Future<List<Organization>> getOwnedOrganizations(
    GetOwnedOrganizationsRef ref) async {
  return ref.watch(modOrganizationRepositoryProvider).getOwnedOrganizations();
}
