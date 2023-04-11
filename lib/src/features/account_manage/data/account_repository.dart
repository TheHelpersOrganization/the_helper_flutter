import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account_manage/domain/account.dart';
import 'package:the_helper/src/features/account_manage/domain/get_account_query.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'account_repository.g.dart';

List<AccountModel> accLst = [
  AccountModel(
    id: 1,
    email: 'AAA@gmail',
    isAccountDisabled: false,
    isAccountVerified: true,
  ),
  AccountModel(
    id: 2,
    email: 'BBB@gmail',
    isAccountDisabled: false,
    isAccountVerified: false,
  ),
];

List<AccountModel> bannedAccLst = [
  AccountModel(
    id: 1,
    email: 'CC@gmail',
    isAccountDisabled: true,
    isAccountVerified: true,
  ),
  AccountModel(
    id: 2,
    email: 'DDD@gmail',
    isAccountDisabled: true,
    isAccountVerified: false,
  ),
];

//Role Repository class
class AccountRepository {
  final Dio client;

  AccountRepository({
    required this.client,
  });

  // Future<List<AccountModel>> getAll(
  //     {int limit = 100, int offset = 0, bool isBanned = false}) async {
  //   // final List<dynamic> res = (await client.get(
  //   //   '/something',
  //   // ))
  //   //     .data['data'];
  //   final List<AccountModel> res = isBanned ? bannedAccLst : accLst;
  //   // return res.map((e) => AccountModel.fromMap(e)).toList();
  //   return res;
  // }

  Future<List<AccountModel>> getAll({
    GetAccountQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/accounts',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => AccountModel.fromJson(e)).toList();
  }

  Future<AccountModel> getById(int id) async {
    final res = await client.get('/something/$id');
    return AccountModel.fromJson(res.data['data']);
  }

  Future<void> create(AccountModel account) async {
    await client.post('/something', data: account.toJson());
  }

  Future<void> update(int id, AccountModel account) async {
    await client.put('/something/$id', data: account.toJson());
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
