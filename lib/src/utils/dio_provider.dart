import 'package:dio/dio.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/auth_service.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/domain_provider.dart';

final dioProvider = Provider((ref) {
  final baseUrl = ref.read(baseUrlProvider);
  final authService = ref.watch(authServiceProvider.notifier);

  final dio = Dio(
    BaseOptions(baseUrl: baseUrl, contentType: "application/json"),
  );
  dio.interceptors
      .add(QueuedInterceptorsWrapper(onRequest: (options, handler) async {
    final token = await authService.getToken();

    if (token == null) {
      return handler.reject(DioError(
          requestOptions: options,
          type: DioErrorType.unknown,
          message: 'Invalid token'));
    }

    final access = token.access;

    options.headers['Authorization'] = "Bearer $access";
    options.connectTimeout = const Duration(seconds: 3000);
    options.receiveTimeout = const Duration(seconds: 3000);

    return handler.next(options);
  }));
  return dio;
});
