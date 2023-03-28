import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:the_helper/src/features/account_manage/domain/account.dart';
import 'package:the_helper/src/utils/dio.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/in_memory_store.dart';

const List<AccountModel> accLst = [
  AccountModel(
    id: 1,
    name: 'qqw',
    email: 'asd@fsdf',
    isAccountDisabled: false,
    isAccountVerified: true,
  ),
  AccountModel(
    id: 2,
    name: 'qqdsw',
    email: 'asd@fsdf',
    isAccountDisabled: false,
    isAccountVerified: false,
  ),
];

const List<AccountModel> bannedAccLst = [
  AccountModel(
    id: 1,
    name: 'qqcccccw',
    email: 'asd@fsdf',
    isAccountDisabled: true,
    isAccountVerified: true,
  ),
  AccountModel(
    id: 2,
    name: 'qqdsw',
    email: 'asd@fsdf',
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

  Future<List<AccountModel>> getAll(
      {int limit = 100, int offset = 0, bool isBanned = false}) async {
    // final List<dynamic> res = (await client.get(
    //   '/something',
    // ))
    //     .data['data'];
    final List<AccountModel> res = isBanned ? accLst : bannedAccLst;
    // return res.map((e) => AccountModel.fromMap(e)).toList();
    return res;
  }

  Future<AccountModel> getById(int id) async {
    final res = await client.get('/something/$id');
    return AccountModel.fromMap(res.data['data']);
  }

  Future<void> create(AccountModel organization) async {
    await client.post('/something', data: organization.toJson());
  }

  Future<void> update(int id, AccountModel organization) async {
    await client.put('/something/$id', data: organization.toJson());
  }

  Future<AccountModel> delete(int id) async {
    final res = await client.delete('/something/$id');
    return AccountModel.fromMap(res.data['data']);
  }
}

final accountRepositoryProvider =
    Provider((ref) => AccountRepository(client: ref.watch(dioProvider)));
