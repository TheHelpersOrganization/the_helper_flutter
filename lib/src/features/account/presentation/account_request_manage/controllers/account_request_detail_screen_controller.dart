import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../utils/async_value.dart';
import '../../../data/account_repository.dart';

part 'account_request_detail_screen_controller.g.dart';

@riverpod
class AccountRequestDetailController extends _$AccountRequestDetailController {
  @override
  FutureOr<void> build() async {}

  Future<void> verifyAccount({
    required int id,
  }) async {
    state = const AsyncValue.loading();
    state = await guardAsyncValue(
        () => ref.watch(accountRepositoryProvider).verifyAccount(accId: id));
    // state = res;
    // return res.valueOrNull;
  }

  // Future<AccountRequestModel> checkIfRequestRejected({
  //   required int id,
  // }) async {

  // }
}
