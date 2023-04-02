import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:the_helper/src/features/account_request_manage/domain/account_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'account_request_repository.g.dart';

List<AccountRequestModel> requestList = [
  AccountRequestModel(
    name: 'AAAA', 
    email: 'AAA@gmail.com', 
    time: DateTime.utc(2023, 1, 1, 06, 00 ,00),
    locations: [
      Location(
        country: 'VietNam',
        region: 'dddd',
        locality: 'adad',
      )
    ]
  ),
];

//Role Repository class
class AccountRequestRepository {
  final Dio client;

  AccountRequestRepository({
    required this.client,
  });

  Future<List<AccountRequestModel>> getAll(
      {int limit = 100, int offset = 0, bool isBanned = false}) async {
    // final List<dynamic> res = (await client.get(
    //   '/something',
    // ))
    //     .data['data'];
    final List<AccountRequestModel> res = requestList;
    // return res.map((e) => AccountRequestModel.fromMap(e)).toList();
    return res;
  }

  Future<AccountRequestModel> getById(int id) async {
    final res = await client.get('/something/$id');
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
