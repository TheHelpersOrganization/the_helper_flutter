import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/features/activity/domain/activity_count.dart';
import 'package:the_helper/src/features/activity/domain/activity_log.dart';
import 'package:the_helper/src/features/activity/domain/activity_log_query.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/account_query.dart';

part 'account_repository.g.dart';

ActivityLog res = ActivityLog(total: 0, monthly: [
  ActivityCount(month: 8, year: 2022, count: 13),
  ActivityCount(month: 9, year: 2022, count: 44),
  ActivityCount(month: 10, year: 2022, count: 20),
  ActivityCount(month: 11, year: 2022, count: 18),
  ActivityCount(month: 12, year: 2022, count: 75),
  ActivityCount(month: 1, year: 2023, count: 13),
  ActivityCount(month: 2, year: 2023, count: 44),
  ActivityCount(month: 3, year: 2023, count: 20),
  ActivityCount(month: 4, year: 2023, count: 18),
  ActivityCount(month: 5, year: 2023, count: 75),
  ActivityCount(month: 6, year: 2023, count: 43),
  ActivityCount(month: 7, year: 2023, count: 11),
  ActivityCount(month: 8, year: 2023, count: 8),
  ActivityCount(month: 9, year: 2023, count: 51),
]);

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

  Future<ActivityLog> getLog({
    ActivityLogQuery? query,
  }) async {
    // final res =
    //     await client.get('/activities/count', queryParameters: query?.toJson());
    // return ActivityLog.fromJson(res.data['data']);
    return res;
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
