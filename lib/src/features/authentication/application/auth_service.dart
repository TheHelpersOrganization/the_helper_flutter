import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:the_helper/src/features/authentication/data/auth_repository.dart';
import 'package:the_helper/src/features/authentication/domain/account_token.dart';
import 'package:the_helper/src/features/authentication/domain/token.dart';

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

  Future<AccountToken?> refreshToken() async {
    final authRepository = ref.read(authRepositoryProvider);
    final res = await authRepository.autoSignIn();
    state = AsyncValue.data(res);
    return res;
  }

  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    await authRepository.signOut();
    state = const AsyncValue.data(null);
  }

  Future<Token?> getToken() async {
    final accountToken = state.valueOrNull;
    if (accountToken == null) {
      return null;
    }

    final access = accountToken.token.accessToken;
    final refresh = accountToken.token.refreshToken;
    final accessTokenHasExpired = JwtDecoder.isExpired(access);
    final refreshTokenHasExpired = JwtDecoder.isExpired(refresh);

    if (refreshTokenHasExpired) {
      await signOut();
      return null;
    }

    if (accessTokenHasExpired) {
      final accountToken = await refreshToken();
      if (accountToken == null) {
        throw Exception('Unable to refresh token');
      }
      return accountToken.token;
    }

    return accountToken.token;
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
