import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/application/account_service.dart';
import 'package:the_helper/src/features/account/domain/account.dart';

part 'profile_verified_controller.g.dart';

@riverpod
class ProfileVerifiedController extends _$ProfileVerifiedController {
  @override
  FutureOr<AccountModel> build(int id) async {
    return _getAccountData(id);
  }

  Future<AccountModel> _getAccountData(int id) async {
    final res = ref.watch(accountServiceProvider).getById(id: id);
    return res;
  }
}
