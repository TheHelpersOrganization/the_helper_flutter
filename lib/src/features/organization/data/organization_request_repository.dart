import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';
import 'package:the_helper/src/features/organization/domain/organization_request_model.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'organization_request_repository.g.dart';

List<OrganizationRequestModel> requestList = [
  OrganizationRequestModel(
      name: 'Test Org Name',
      email: 'test@gmail.com',
      phoneNumber: '012345678911',
      description:
          'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
      website: 'website.com',
      files: [
        const FileModel(id: 1, name: 'file 1', mimetype: 'zip'),
        const FileModel(id: 2, name: 'file 2', mimetype: 'zip'),
        const FileModel(id: 3, name: 'file 3', mimetype: 'rar'),
        const FileModel(id: 4, name: 'file 4', mimetype: 'zip'),
        const FileModel(id: 5, name: 'file 5', mimetype: 'txt'),
      ],
      locations: [
        '268 Lý Thường Kiệt,\n Phường 14, Quận 10, Thành phố Hồ Chí Minh, VN',
      ]),
];

//Role Repository class
class OrganizationRequestModelRepository {
  final Dio client;

  OrganizationRequestModelRepository({
    required this.client,
  });

  Future<List<OrganizationRequestModel>> getAll({
    int limit = 100,
    int offset = 0,
    int? status,
    // OrganizationQuery? query,
  }) async {
    print('aaaa');
    // final List<dynamic> res = (await client.get(
    //   '/something',
    // ))
    //     .data['data'];
    final List<OrganizationRequestModel> res = requestList;
    // return res.map((e) => OrganizationRequestModel.fromMap(e)).toList();
    return res;
  }

  Future<OrganizationRequestModel> getById(int id) async {
    // final res = await client.get('/something/$id');
    // return OrganizationRequestModel.fromJson(res.data['data']);
    final OrganizationRequestModel res = requestList[id];
    return res;
  }

  Future<void> create(OrganizationRequestModel account) async {
    await client.post('/something', data: account.toJson());
  }

  Future<void> update(int id, OrganizationRequestModel account) async {
    await client.put('/something/$id', data: account.toJson());
  }

  Future<OrganizationRequestModel> delete(int id) async {
    final res = await client.delete('/something/$id');
    return OrganizationRequestModel.fromJson(res.data['data']);
  }
}

// final accountRepositoryProvider =
//     Provider((ref) => AccountRepository(client: ref.watch(dioProvider)));

@riverpod
OrganizationRequestModelRepository organizationRequestModelRepository(
        OrganizationRequestModelRepositoryRef ref) =>
    OrganizationRequestModelRepository(client: ref.watch(dioProvider));

@riverpod
Future<OrganizationRequestModel> getOrganizationRequestModel(
  GetOrganizationRequestModelRef ref,
  int orgId,
) =>
    ref.watch(organizationRequestModelRepositoryProvider).getById(orgId);

@riverpod
Future<List<OrganizationRequestModel>> getOrganizationRequestModels(
  GetOrganizationRequestModelsRef ref,
) =>
    ref.watch(organizationRequestModelRepositoryProvider).getAll();
