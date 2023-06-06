import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/account_query.dart';

part 'account_repository.g.dart';

// List<AccountModel> accLst = [
//   AccountModel(
//     id: 1,
//     email: 'AAA@gmail',
//     isAccountDisabled: false,
//     isAccountVerified: true,
//   ),
//   AccountModel(
//     id: 2,
//     email: 'BBB@gmail',
//     isAccountDisabled: false,
//     isAccountVerified: false,
//   ),
// ];

// List<AccountModel> bannedAccLst = [
//   AccountModel(
//     id: 1,
//     email: 'CC@gmail',
//     isAccountDisabled: true,
//     isAccountVerified: true,
//   ),
//   AccountModel(
//     id: 2,
//     email: 'DDD@gmail',
//     isAccountDisabled: true,
//     isAccountVerified: false,
//   ),
// ];

//Role Repository class
class AccountRepository {
  final Dio client;

  AccountRepository({
    required this.client,
  });

  Future<List<AccountModel>> getAll({
    AccountQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/admin/accounts',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => AccountModel.fromJson(e)).toList();
    // final List<AccountModel> res = isBanned != 0 ? bannedAccLst : accLst;
    // return res;
  }

  Future<AccountModel> getById(int id) async {
    final res = await client.get('/something/$id');
    return AccountModel.fromJson(res.data['data']);
  }

  Future<void> create(AccountModel account) async {
    await client.post('/something', data: account.toJson());
  }

  Future<AccountModel> banAccount({
    required int accId,
  }) async {
    final res = await client.put('/admin/accounts/$accId/ban',
        data: {"isBanned": true, "note": "Banned!"});
    return AccountModel.fromJson(res.data['data']);
  }

  Future<AccountModel> unbanAccount({
    required int accId,
  }) async {
    final res = await client.put('/admin/accounts/$accId/ban',
        data: {"isBanned": false, "note": "Unbanned!"});
    return AccountModel.fromJson(res.data['data']);
  }

  Future<AccountModel> delete(int id) async {
    final res = await client.delete('/something/$id');
    return AccountModel.fromJson(res.data['data']);
  }
}

// final accountRepositoryProvider =
//     Provider((ref) => AccountRepository(client: ref.watch(dioProvider)));

@riverpod
AccountRepository accountRepository(AccountRepositoryRef ref) =>
    AccountRepository(client: ref.watch(dioProvider));

@riverpod
Future<AccountModel> getAccount(
  GetAccountRef ref,
  int accountId,
) =>
    ref.watch(accountRepositoryProvider).getById(accountId);

@riverpod
Future<List<AccountModel>> getAccounts(
  GetAccountsRef ref,
) =>
    ref.watch(accountRepositoryProvider).getAll();
