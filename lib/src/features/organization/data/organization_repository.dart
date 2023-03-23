import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/domain/organization_query.dart';
import 'package:the_helper/src/utils/dio_provider.dart';

import '../domain/organization_model.dart';

class OrganizationRepository {
  final Dio client;

  OrganizationRepository({required this.client});

  Future<List<OrganizationModel>> getAll({
    int limit = 100,
    int offset = 0,
    OrganizationQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/organizations',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => OrganizationModel.fromMap(e)).toList();
  }

  Future<OrganizationModel> getById(int id) async {
    final res = await client.get('/locations/$id');
    return OrganizationModel.fromMap(res.data['data']);
  }

  Future<void> create(OrganizationModel organization) async {
    await client.post('/locations', data: organization.toJson());
  }

  Future<void> update(int id, OrganizationModel organization) async {
    await client.put('/locations/$id', data: organization.toJson());
  }

  Future<OrganizationModel> delete(int id) async {
    final res = await client.delete('/locations/$id');
    return OrganizationModel.fromMap(res.data['data']);
  }
}

final organizationRepositoryProvider =
    Provider((ref) => OrganizationRepository(client: ref.watch(dioProvider)));
