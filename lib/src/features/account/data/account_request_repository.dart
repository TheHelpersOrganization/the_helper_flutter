import 'package:dio/dio.dart';
import 'package:the_helper/src/common/domain/file_info.dart';

import 'package:the_helper/src/features/account/domain/account_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/domain/account_request_query.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'account_request_repository.g.dart';

List<AccountRequestModel> requestList = [
  // AccountRequestModel(
  //   name: 'AAAA',
  //   email: 'AAA@gmail.com',
  //   time: DateTime.utc(2023, 1, 1, 06, 00 ,00),
  //   locations: [
  //     Location(
  //       country: 'VietNam',
  //       region: 'dddd',
  //       locality: 'adad',
  //     )
  //   ]
  // ),
  AccountRequestModel(
      accountId: 205,
      status: 'pending',
      isVerified: true,
      note: "asdfaefasvsasf",
      createdAt: DateTime.utc(2023, 1, 1, 06, 00, 00),
      files: [
        FileInfoModel(
            name: "Filename",
            internalName: "internalName",
            mimetype: "mimetype",
            size: 200,
            sizeUnit: "sizeUnit"),
        FileInfoModel(
            name: "ADF",
            internalName: "internalName",
            mimetype: "mimetype",
            size: 20,
            sizeUnit: "sizeUnit"),
      ])
];

//Role Repository class
class AccountRequestRepository {
  final Dio client;

  AccountRequestRepository({
    required this.client,
  });

  Future<List<AccountRequestModel>> getAll({
    AccountRequestQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/account-verifications',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => AccountRequestModel.fromJson(e)).toList();
    // final List<AccountRequestModel> res = requestList;
    // return res;
  }

  Future<AccountRequestModel> getById(int id) async {
    final res =
        await client.get('/account-verifications/$id', queryParameters: {
      "include": "file",
    });
    return AccountRequestModel.fromJson(res.data['data']);
  }

  Future<void> create(AccountRequestModel account) async {
    await client.post('/something', data: account.toJson());
  }

  Future<void> update(int id, AccountRequestModel account) async {
    await client.put('/something/$id', data: account.toJson());
  }

  Future<AccountRequestModel> delete(int id) async {
    final res = await client.delete('/something/$id');
    return AccountRequestModel.fromJson(res.data['data']);
  }
}

// final accountRepositoryProvider =
//     Provider((ref) => AccountRepository(client: ref.watch(dioProvider)));

@riverpod
AccountRequestRepository accountRequestRepository(
        AccountRequestRepositoryRef ref) =>
    AccountRequestRepository(client: ref.watch(dioProvider));

@riverpod
Future<AccountRequestModel> getAccountRequest(
  GetAccountRequestRef ref,
  int accountId,
) =>
    ref.watch(accountRequestRepositoryProvider).getById(accountId);

@riverpod
Future<List<AccountRequestModel>> getAccountRequests(
  GetAccountRequestsRef ref,
) =>
    ref.watch(accountRequestRepositoryProvider).getAll();
