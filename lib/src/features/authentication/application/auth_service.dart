import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:the_helper/src/features/authentication/data/auth_repository.dart';
import 'package:the_helper/src/features/authentication/domain/account_token.dart';
import 'package:the_helper/src/features/authentication/domain/token.dart';

class AuthService extends AsyncNotifier<AccountToken?> {
  final List<void Function(AccountToken? token)> _onAfterSignInCallbacks = [];
  final List<void Function(AccountToken? token)> _onAfterSignOutCallbacks = [];

  @override
  FutureOr<AccountToken?> build() async {
    final authRepository = ref.read(authRepositoryProvider);
    final accountToken = await authRepository.autoSignIn();
    _onAfterSignIn(accountToken);
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
    _onAfterSignOut(state.valueOrNull);
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

  addOnAfterSignInCallback(void Function(AccountToken? token) callback) {
    _onAfterSignInCallbacks.add(callback);
  }

  removeOnAfterSignInCallback(void Function(AccountToken? token) callback) {
    _onAfterSignInCallbacks.remove(callback);
  }

  addOnAfterSignOutCallback(void Function(AccountToken? token) callback) {
    _onAfterSignOutCallbacks.add(callback);
  }

  removeOnAfterSignOutCallback(void Function(AccountToken? token) callback) {
    _onAfterSignOutCallbacks.remove(callback);
  }

  void _onAfterSignIn(AccountToken? token) {
    for (final callback in _onAfterSignInCallbacks) {
      callback(token);
    }
  }

  void _onAfterSignOut(AccountToken? token) {
    for (final callback in _onAfterSignOutCallbacks) {
      callback(token);
    }
  }
}

final authServiceProvider =
    AsyncNotifierProvider<AuthService, AccountToken?>(() => AuthService());
