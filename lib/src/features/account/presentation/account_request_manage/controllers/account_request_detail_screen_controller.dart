import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/data/account_request_repository.dart';
import 'package:the_helper/src/features/account/domain/account_request_query.dart';

import '../../../../../utils/async_value.dart';
import '../../../data/account_repository.dart';
import '../../../domain/account_request.dart';

part 'account_request_detail_screen_controller.g.dart';

@riverpod
class AccountRequestDetailController extends _$AccountRequestDetailController {
  @override
  FutureOr<AccountRequestModel> build({required int id}) async {
    return fetchRequest(id);
  }

  Future<AccountRequestModel> fetchRequest(int id) async {
    final repository = ref.watch(accountRequestRepositoryProvider);
    final res = await repository.getById(id: id);
    return res;
  }
}

@riverpod
class VerifiedAccountController extends _$VerifiedAccountController {
  @override
  FutureOr<void> build() {}

  Future<void> verifyAccount({
      required int accountId,
    }) async {
      state = const AsyncValue.loading();
      state = await guardAsyncValue(
          () => ref.watch(accountRepositoryProvider).verifyAccount(accId: accountId));
    }
  
  Future<void> rejectAccount({
      required int requestId,
    }) async {
      state = const AsyncValue.loading();
      state = await guardAsyncValue(
          () => ref.watch(accountRequestRepositoryProvider).reject(requestId: requestId));
    }

  Future<void> blockRequest({
      required int requestId,
    }) async {
      state = const AsyncValue.loading();
      state = await guardAsyncValue(
          () => ref.watch(accountRequestRepositoryProvider).block(requestId: requestId));
    }
  
  Future<void> unblockRequest({
      required int requestId,
    }) async {
      state = const AsyncValue.loading();
      state = await guardAsyncValue(
          () => ref.watch(accountRequestRepositoryProvider).unblock(requestId: requestId));
    }
}

final requestHistoryProvider = FutureProvider.autoDispose
    .family<List<AccountRequestModel>, int>((ref, accountId) => ref
        .watch(accountRequestRepositoryProvider)
        .getAll(query: AccountRequestQuery(accountId: accountId)));