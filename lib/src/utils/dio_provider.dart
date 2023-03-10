import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/auth_service.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/auth_repository.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/domain_provider.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final baseUrl = ref.read(baseUrlProvider);
  final authRepository = ref.read(authRepositoryProvider);
  final dio = Dio(
    BaseOptions(baseUrl: baseUrl, contentType: "application/json"),
  );
  dio.interceptors
      .add(QueuedInterceptorsWrapper(onRequest: (options, handler) async {
    final _auth = ref.read(authServiceProvider).valueOrNull;

    String? access = _auth?.token.access;
    String? refresh = _auth?.token.refresh;
    if (access == null || refresh == null) {
      return handler.reject(DioError(
          requestOptions: options,
          type: DioErrorType.unknown,
          message: 'Missing token'));
    }

    final accessTokenHasExpired = JwtDecoder.isExpired(access);
    final refreshTokenHasExpired = JwtDecoder.isExpired(refresh);
    if (refreshTokenHasExpired) {
      await authRepository.signOut();
      return handler.reject(DioError(
          requestOptions: options,
          type: DioErrorType.unknown,
          message: 'Expired token'));
    }
    if (accessTokenHasExpired) {
      print('access token expired');
      final accountToken = await authRepository.autoSignIn();
      if (accountToken == null) {
        return handler.reject(DioError(
            requestOptions: options,
            type: DioErrorType.unknown,
            message: 'Unable to refresh token'));
      }
      access = accountToken.token.access;
      refresh = accountToken.token.refresh;
    }

    options.headers['Authorization'] = "Bearer $access";
    options.connectTimeout = const Duration(seconds: 3000);
    options.receiveTimeout = const Duration(seconds: 3000);

    return handler.next(options);
  }));
  return dio;
}
