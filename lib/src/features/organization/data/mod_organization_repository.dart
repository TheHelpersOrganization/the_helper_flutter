import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/dio.dart';
import '../domain/organization.dart';
import '../domain/organization_query.dart';

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

  Future<Organization> getOwnedOrganizationById(int id) async {
    final res = await client.get('/mod/organizations/$id');
    return Organization.fromJson(res.data['data']);
  }

  Future<Organization> modCreate(Organization organization) async {
    final res =
        await client.post('/organizations', data: organization.toJson());
    return Organization.fromJson(res.data['data']);
  }

  Future<void> modUpdate(int id, Organization organization) async {
    await client.put('/organization/$id', data: organization.toJson());
  }
}

@riverpod
ModOrganizationRepository modOrganizationRepository(
        ModOrganizationRepositoryRef ref) =>
    ModOrganizationRepository(client: ref.watch(dioProvider));
