import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/domain/data_log.dart';
import 'package:the_helper/src/features/activity/domain/activity_log_query.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../data/account_repository.dart';
import '../data/account_request_repository.dart';
import '../domain/account.dart';
import '../domain/account_log_query.dart';
import '../domain/account_query.dart';
import '../domain/account_request_log_query.dart';
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

  Future<DataLog> getLog({
    AccountLogQuery? query,
  }) async {
    DataLog log = await accountRepository.getLog(query: query);
    return log;
  }

  Future<DataLog> getRequestLog({
    AccountRequestLogQuery? query,
  }) async {
    DataLog log = await accountRequestRepository.getLog(query: query);
    return log;
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
