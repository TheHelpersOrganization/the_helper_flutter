import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:simple_auth_flutter_riverpod/src/features/admin/account_manage/domain/account.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/dio_provider.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/domain_provider.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/in_memory_store.dart';

//Role Repository class
class AccountRepository {
  final Dio client;
  final String url;
  final _accountList = InMemoryStore<Account?>(null);

  AccountRepository({
    required this.client,
    required this.url,
  });

  Future<void> getAccountList(String userID) async {
    final response = await client.get(
      '$url/somthing',
      data: {
        'id': userID,
      },
    );
    _accountList.value = Account.fromMap(response.data['data']);
  }
}

final accountRepositoryProvider = Provider<Account?>((ref) {
  final accountList = AccountRepository(
    client: ref.read(dioProvider),
    url: ref.read(baseUrlProvider),
  );
  return accountList._accountList.value;
});

// final roleStateChangeProvider = 
