import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity_count.dart';
import 'package:the_helper/src/features/activity/domain/activity_log.dart';
import 'package:the_helper/src/features/activity/domain/activity_log_query.dart';

import '../../../utils/dio.dart';
import '../domain/admin_organization.dart';
import '../domain/admin_organization_query.dart';

part 'admin_organization_repository.g.dart';

ActivityLog res = ActivityLog(total: 0, monthly: [
  ActivityCount(month: 8, year: 2022, count: 13),
  ActivityCount(month: 9, year: 2022, count: 44),
  ActivityCount(month: 10, year: 2022, count: 20),
  ActivityCount(month: 11, year: 2022, count: 18),
  ActivityCount(month: 12, year: 2022, count: 25),
  ActivityCount(month: 1, year: 2023, count: 13),
  ActivityCount(month: 2, year: 2023, count: 44),
  ActivityCount(month: 3, year: 2023, count: 20),
  ActivityCount(month: 4, year: 2023, count: 18),
  ActivityCount(month: 5, year: 2023, count: 75),
  ActivityCount(month: 6, year: 2023, count: 43),
  ActivityCount(month: 7, year: 2023, count: 11),
  ActivityCount(month: 8, year: 2023, count: 8),
]);

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
      '/admin/organizations/$id/reject',
    );
    return AdminOrganization.fromJson(res.data['data']);
  }

  Future<ActivityLog> getLog({
    ActivityLogQuery? query,
  }) async {
    // final res =
    //     await client.get('/activities/count', queryParameters: query?.toJson());
    // return ActivityLog.fromJson(res.data['data']);
    return res;
  }
}

@riverpod
AdminOrganizationRepository adminOrganizationRepository(
        AdminOrganizationRepositoryRef ref) =>
    AdminOrganizationRepository(client: ref.watch(dioProvider));
