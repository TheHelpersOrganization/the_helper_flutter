import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization/domain/reject_organization_data.dart';

import '../../../utils/dio.dart';
import '../domain/organization.dart';
import '../domain/organization_query.dart';

part 'admin_organization_repository.g.dart';

class AdminOrganizationRepository {
  final Dio client;

  AdminOrganizationRepository({required this.client});

  Future<List<Organization>> getAll({
    OrganizationQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/admin/organizations',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => Organization.fromJson(e)).toList();
    // return status == 0 ? lst : lst2;
  }

  Future<Organization> getById(int id) async {
    final res = await client.get('/admin/organizations/$id');
    return Organization.fromJson(res.data['data']);
  }

  Future<Organization> ban(int id) async {
    final res = await client.post('/admin/organizations/$id/disable');
    return Organization.fromJson(res.data['data']);
  }

  Future<Organization> unban(int id) async {
    final res = await client.post('/admin/organizations/$id/verify');
    return Organization.fromJson(res.data['data']);
  }

  Future<Organization> verify(int id) async {
    final res = await client.post('/admin/organizations/$id/verify');
    return Organization.fromJson(res.data['data']);
  }

  Future<Organization> reject(int id) async {
    final res = await client.post(
      '/admin/organizations/$id/reject',);
    return Organization.fromJson(res.data['data']);
  }
}

@riverpod
AdminOrganizationRepository adminOrganizationRepository(
        AdminOrganizationRepositoryRef ref) =>
    AdminOrganizationRepository(client: ref.watch(dioProvider));
