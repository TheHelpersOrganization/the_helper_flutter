import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';
import 'package:the_helper/src/features/authentication/domain/account_token.dart';
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
      final err = BackendException.fromMap(ex.response?.data);
      print('Cannot sign in: $err');
      return Future.error(err);
    }
  }

  // Future<AccountToken?> register(String email, String password) async {
  //   try {
  //     final response = await client.post(
  //       '$url/auth/register',
  //       data: {
  //         "email": email,
  //         "password": password,
  //       },
  //     );
  //     final accountToken = AccountToken.fromMap(response.data['data']);
  //     await _saveCredentialsToLocalStorage(accountToken.token);
  //     return accountToken;
  //   } on DioError catch (ex) {
  //     return Future.error(Back)
  //   }
  // }

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

  // TODO: register method
  // TODO: password recovery
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = AuthRepository(
    client: ref.read(rawDioProvider),
    url: ref.read(baseUrlProvider),
    localStorage: ref.read(secureStorageProvider),
  );
  return auth;
});
