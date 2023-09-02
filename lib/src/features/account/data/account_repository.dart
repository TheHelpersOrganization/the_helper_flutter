import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/domain/data_log.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/features/activity/domain/activity_log_query.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/account_log_query.dart';
import '../domain/account_query.dart';

part 'account_repository.g.dart';

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

  Future<AccountModel> verifyAccount({
    required int accId,
  }) async {
    final res = await client.put('/admin/accounts/$accId/verify',
        data: {"isVerified": true, "note": "Admin has verified your account"});
    return AccountModel.fromJson(res.data['data']);
  }

  Future<AccountModel> delete(int id) async {
    final res = await client.delete('/something/$id');
    return AccountModel.fromJson(res.data['data']);
  }

  Future<DataLog> getLog({
    AccountLogQuery? query,
  }) async {
    final res =
        await client.get('/accounts/count', queryParameters: query?.toJson());
    return DataLog.fromJson(res.data['data']);
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
