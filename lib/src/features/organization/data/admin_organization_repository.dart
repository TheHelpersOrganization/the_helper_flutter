import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/dio.dart';
import '../domain/admin_organization.dart';
import '../domain/admin_organization_query.dart';
import '../domain/organization.dart';

part 'admin_organization_repository.g.dart';

class AdminOrganizationRepository {
  final Dio client;

  AdminOrganizationRepository({required this.client});

  Future<List<AdminOrganization>> getAll({
    AdminOrganizationQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/admin/organizations',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => AdminOrganization.fromJson(e)).toList();
    // return status == 0 ? lst : lst2;
  }

  Future<AdminOrganization> getById(int id) async {
    final res = await client.get('/admin/organizations/$id');
    return AdminOrganization.fromJson(res.data['data']);
  }

  Future<AdminOrganization> ban(int id) async {
    final res = await client.post('/admin/organizations/$id/disable');
    return AdminOrganization.fromJson(res.data['data']);
  }

  Future<AdminOrganization> unban(int id) async {
    final res = await client.post('/admin/organizations/$id/enable');
    return AdminOrganization.fromJson(res.data['data']);
  }

  Future<AdminOrganization> verify(int id) async {
    final res = await client.post('/admin/organizations/$id/verify');
    return AdminOrganization.fromJson(res.data['data']);
  }

  Future<AdminOrganization> reject(int id) async {
    final res = await client.post(
      '/admin/organizations/$id/reject',);
    return AdminOrganization.fromJson(res.data['data']);
  }
}

@riverpod
AdminOrganizationRepository adminOrganizationRepository(
        AdminOrganizationRepositoryRef ref) =>
    AdminOrganizationRepository(client: ref.watch(dioProvider));
