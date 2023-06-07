import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../data/account_repository.dart';
import '../domain/account.dart';
import '../domain/account_query.dart';

part 'account_service.g.dart';

class AccountService {
  final Dio client;
  final AccountRepository accountRepository;

  const AccountService({
    required this.client,
    required this.accountRepository,
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
  }

  Future<int> getCount({
    AccountQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/admin/accounts',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => AccountModel.fromJson(e)).toList().length;
  }
}

@riverpod
AccountService accountService(AccountServiceRef ref) {
  return AccountService(
    client: ref.watch(dioProvider),
    accountRepository: ref.watch(accountRepositoryProvider),
  );
}
