import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:the_helper/src/features/organization_manage/domain/organization_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'organization_model_repository.g.dart';

List<OrganizationModel> requestList = [
  OrganizationModel(
    name: 'Org AAAA', 
    email: 'aaa@gmail.com', 
    description: 'description'
  ),
];

//Role Repository class
class OrganizationModelRepository {
  final Dio client;

  OrganizationModelRepository({
    required this.client,
  });

  Future<List<OrganizationModel>> getAll(
      {
        int limit = 100, 
        int offset = 0, 
        int status = 0
      }) async {
    // final List<dynamic> res = (await client.get(
    //   '/something',
    // ))
    //     .data['data'];
    final List<OrganizationModel> res = requestList;
    // return res.map((e) => OrganizationModel.fromMap(e)).toList();
    return res;
  }

  Future<OrganizationModel> getById(int id) async {
    final res = await client.get('/something/$id');
    return OrganizationModel.fromJson(res.data['data']);
  }

  Future<void> create(OrganizationModel account) async {
    await client.post('/something', data: account.toJson());
  }

  Future<void> update(int id, OrganizationModel account) async {
    await client.put('/something/$id', data: account.toJson());
  }

  Future<OrganizationModel> delete(int id) async {
    final res = await client.delete('/something/$id');
    return OrganizationModel.fromJson(res.data['data']);
  }
}

// final accountRepositoryProvider =
//     Provider((ref) => AccountRepository(client: ref.watch(dioProvider)));

@riverpod
OrganizationModelRepository organizationModelRepository(
        OrganizationModelRepositoryRef ref) =>
    OrganizationModelRepository(client: ref.watch(dioProvider));

@riverpod
Future<OrganizationModel> getOrganizationModel(
  GetOrganizationModelRef ref,
  int accountId,
) =>
    ref.watch(organizationModelRepositoryProvider).getById(accountId);

@riverpod
Future<List<OrganizationModel>> getOrganizationModels(
  GetOrganizationModelsRef ref,
) =>
    ref.watch(organizationModelRepositoryProvider).getAll();
