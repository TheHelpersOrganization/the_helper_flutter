import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/utils/dio.dart';

// import '../domain/organization_model.dart';
import '../domain/organization.dart';
import '../domain/organization_query.dart';

part 'organization_repository.g.dart';

class OrganizationRepository {
  final Dio client;

  OrganizationRepository({required this.client});

  Future<List<Organization>> getOrgsQ(
      {Map<String, dynamic>? queryParameters}) async {
    final List<dynamic> res =
        (await client.get('/organizations', queryParameters: queryParameters))
            .data['data'];
    return res.map((data) => Organization.fromJson(data)).toList();
  }

  Future<List<Organization>> getAll({
    OrganizationQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/organizations',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => Organization.fromJson(e)).toList();
  }

  Future<Organization> getById(int id) async {
    final res = await client.get('/organizations/$id');
    return Organization.fromJson(res.data['data']);
  }
}

// final organizationRepositoryProvider =
// Provider((ref) => OrganizationRepository(client: ref.watch(dioProvider)));

@riverpod
OrganizationRepository organizationRepository(OrganizationRepositoryRef ref) =>
    OrganizationRepository(client: ref.watch(dioProvider));

@riverpod
Future<Organization> getOrganization(
  GetOrganizationRef ref,
  int organizationId,
) =>
    ref.watch(organizationRepositoryProvider).getById(organizationId);

@riverpod
Future<List<Organization>> getOrganizations(
  GetOrganizationsRef ref,
) =>
    ref.watch(organizationRepositoryProvider).getAll();
