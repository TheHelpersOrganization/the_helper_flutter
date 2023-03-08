import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/auth_repository.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/domain/account_token.dart';

class AuthService extends AsyncNotifier<AccountToken?> {
  @override
  FutureOr<AccountToken?> build() async {
    final authRepository = ref.read(authRepositoryProvider);
    final accountToken = await authRepository.autoSignIn();
    return accountToken;
  }

  Future<void> signIn(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    final res = await authRepository.signIn(email, password);
    state = AsyncValue.data(res);
  }

  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> sendOtp() async {
    final accountToken = state.valueOrNull;
    if (accountToken == null) {
      throw Exception('You must login to perform this action');
    }
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.sendOtp(accountToken.account.email);
  }

  Future<void> verifyAccount(String otp) async {
    final accountToken = state.valueOrNull;
    if (accountToken == null) {
      throw Exception('You must login to perform this action');
    }
    final authRepository = ref.read(authRepositoryProvider);
    final account =
        await authRepository.verifyAccount(accountToken.account.email, otp);
    final updatedAccountToken = accountToken.copyWith(account: account);
    state = AsyncValue.data(updatedAccountToken);
  }
}

final authServiceProvider =
    AsyncNotifierProvider<AuthService, AccountToken?>(() => AuthService());
