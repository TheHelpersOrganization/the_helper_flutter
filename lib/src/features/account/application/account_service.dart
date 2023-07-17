import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../data/account_repository.dart';
import '../data/account_request_repository.dart';
import '../domain/account.dart';
import '../domain/account_query.dart';
import '../domain/account_request.dart';
import '../domain/account_request_query.dart';

part 'account_service.g.dart';

class AccountService {
  final Dio client;
  final AccountRepository accountRepository;
  final AccountRequestRepository accountRequestRepository;

  const AccountService({
    required this.client,
    required this.accountRepository,
    required this.accountRequestRepository,
  });

  Future<List<AccountModel>> getAll({
    AccountQuery? query,
  }) async {
    final accounts = await accountRepository.getAll(
      query: query,
    );
    return accounts;
  }

  Future<int> getCount({
    AccountQuery? query,
  }) async {
    final accounts = await accountRepository.getAll(
      query: query,
    );
    return accounts.length;
  }

  Future<int> getRequestCount({
    AccountRequestQuery? query,
  }) async {
    final request = await accountRequestRepository.getAll(query: query);
    return request.length;
  }
}

@riverpod
AccountService accountService(AccountServiceRef ref) {
  return AccountService(
    client: ref.watch(dioProvider),
    accountRepository: ref.watch(accountRepositoryProvider),
    accountRequestRepository: ref.watch(accountRequestRepositoryProvider),
  );
}
