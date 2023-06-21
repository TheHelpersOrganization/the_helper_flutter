import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/data/account_request_repository.dart';
import 'package:the_helper/src/features/account/domain/account_request.dart';
import 'package:the_helper/src/features/profile/application/profile_service.dart';

import '../../../../../utils/async_value.dart';
import '../../../../profile/domain/profile.dart';
import '../../../data/account_repository.dart';
import '../../../domain/account.dart';

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
