import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';
import 'package:the_helper/src/features/authentication/domain/account_token.dart';
import 'package:the_helper/src/features/authentication/domain/request_reset_password.dart';
import 'package:the_helper/src/features/authentication/domain/reset_password.dart';
import 'package:the_helper/src/features/authentication/domain/verify_reset_password_token.dart';
import 'package:the_helper/src/utils/flutter_secure_storage_provider.dart';
import 'package:the_helper/src/utils/raw_dio_provider.dart';

import '../../../utils/domain_provider.dart';
import '../domain/account.dart';
import '../domain/token.dart';

class AuthRepository {
  AuthRepository({
    required this.client,
    required this.url,
    required this.localStorage,
  });

  final Dio client;
  final String url;
  final FlutterSecureStorage localStorage;

  Future<AccountToken?> signIn(String email, String password) async {
    try {
      final response = await client.post(
        '$url/auth/login',
        data: {
          "email": email,
          "password": password,
        },
      );
      final accountToken = AccountToken.fromJson(response.data['data']);
      await _saveCredentialsToLocalStorage(accountToken.token);
      return accountToken;
    } on DioException catch (ex) {
      return Future.error(BackendException.fromMap(ex.response?.data));
    }
  }

  Future<Account?> register(String email, String password) async {
    try {
      final response = await client.post(
        '$url/auth/register',
        data: {
          "email": email,
          "password": password,
        },
      );
      final accountToken = Account.fromJson(response.data['data']);
      //await _saveCredentialsToLocalStorage(accountToken.token);
      return accountToken;
    } on DioException catch (ex) {
      return Future.error(BackendException.fromMap(ex.response?.data));
    }
  }

  Future<AccountToken?> autoSignIn() async {
    final refreshToken = await localStorage.read(key: 'auth.refreshToken');
    if (refreshToken == null) {
      return null;
    }
    try {
      final response = await client.post(
        '$url/auth/refresh-token',
        data: {
          "refreshToken": refreshToken,
        },
      );
      final accountToken = AccountToken.fromJson(response.data['data']);
      await _saveCredentialsToLocalStorage(accountToken.token);
      return accountToken;
    } catch (err) {
      return null;
    }
  }

  Future<void> signOut() async {
    await localStorage.delete(key: 'auth.accessToken');
    await localStorage.delete(key: 'auth.refreshToken');
  }

  Future<void> _saveCredentialsToLocalStorage(Token token) async {
    await localStorage.write(key: 'auth.accessToken', value: token.accessToken);
    await localStorage.write(
      key: 'auth.refreshToken',
      value: token.refreshToken,
    );
  }

  Future<void> sendOtp(String email) async {
    try {
      final response = await client.post(
        '$url/auth/verify-account-token',
        data: {
          'email': email,
        },
      );
    } on DioException catch (ex) {
      return Future.error(BackendException.fromMap(ex.response?.data));
    }
  }

  Future<Account> verifyAccount(String email, String otp) async {
    try {
      final response = await client.post(
        '$url/auth/verify-account',
        data: {
          'email': email,
          'token': otp,
        },
      );
      final account = Account.fromJson(response.data['data']);
      return account;
    } on DioException catch (ex) {
      return Future.error(BackendException.fromMap(ex.response?.data));
    }
  }

  Future<void> requestResetPassword(RequestResetPassword data) async {
    await client.post(
      '$url/auth/request-reset-password',
      data: data.toJson(),
    );
  }

  Future<bool> verifyResetPasswordToken(VerifyResetPasswordToken data) async {
    final res = await client.post(
      '$url/auth/verify-reset-password-token',
      data: data.toJson(),
    );

    return res.data['data'];
  }

  Future<Account> resetPassword(ResetPassword data) async {
    final res = await client.post(
      '$url/auth/reset-password',
      data: data.toJson(),
    );
    return Account.fromJson(res.data['data']);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = AuthRepository(
    client: ref.read(rawDioProvider),
    url: ref.read(baseUrlProvider),
    localStorage: ref.read(secureStorageProvider),
  );
  return auth;
});
