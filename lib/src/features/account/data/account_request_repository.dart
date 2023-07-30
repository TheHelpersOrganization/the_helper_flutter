import 'package:dio/dio.dart';

import 'package:the_helper/src/features/account/domain/account_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/domain/account_request_query.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'account_request_repository.g.dart';

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

  Future<AccountRequestModel> getById({
    required int id,
    AccountRequestQuery? query,
  }) async {
    final res = await client.get('/account-verifications/$id',
        queryParameters: query?.toJson());
    return AccountRequestModel.fromJson(res.data['data']);
  }

  Future<void> create(AccountRequestModel account) async {
    await client.post('/something', data: account.toJson());
  }

  Future<AccountRequestModel> reject({
    required int requestId,
  }) async {
    final res = await client.put('/admin/accounts/$requestId/something',
        data: {"isVerified": true, "note": "Admin has verified your account"});
    return AccountRequestModel.fromJson(res.data['data']);
  }

  Future<AccountRequestModel> block({
    required int requestId
  }) async {
    final res = await client.put('/account-verifications/$requestId/block');
    return AccountRequestModel.fromJson(res.data['data']);
  }

  Future<AccountRequestModel> unblock({
    required int requestId
  }) async {
    final res = await client.put('/account-verifications/$requestId/unblock');
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
    ref.watch(accountRequestRepositoryProvider).getById(
        id: accountId,
        query: AccountRequestQuery(include: [AccountRequestInclude.file]));

@riverpod
Future<List<AccountRequestModel>> getAccountRequests(
  GetAccountRequestsRef ref,
) =>
    ref.watch(accountRequestRepositoryProvider).getAll();
