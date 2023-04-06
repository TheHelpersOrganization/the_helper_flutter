import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

import '../features/authentication/application/auth_service.dart';

part 'dio.g.dart';
// final dioProvider = Provider((ref) {
//   final baseUrl = ref.read(baseUrlProvider);
//   final authService = ref.watch(authServiceProvider.notifier);

//   final dio = Dio(
//     BaseOptions(baseUrl: baseUrl, contentType: "application/json"),
//   );
//   dio.interceptors
//       .add(QueuedInterceptorsWrapper(onRequest: (options, handler) async {
//     final token = await authService.getToken();

//     if (token == null) {
//       return handler.reject(DioError(
//           requestOptions: options,
//           type: DioErrorType.unknown,
//           message: 'Invalid token'));
//     }

//     final access = token.access;

//     options.headers['Authorization'] = "Bearer $access";
//     options.connectTimeout = const Duration(seconds: 3000);
//     options.receiveTimeout = const Duration(seconds: 3000);

//     return handler.next(options);
//   }));
//   dio.interceptors.add(InterceptorsWrapper(onError: (err, handler) {
//     if (err.response?.data?['error'] != null) {
//       try {
//         final backendExceptionData = BackendExceptionData.fromMap(
//             err.response!.data?['error'] as Map<String, dynamic>);
//         final backendException = BackendException(
//             error: backendExceptionData, requestOptions: err.requestOptions);

//         return handler.reject(backendException);
//       } catch (ex) {
//         return handler.next(err);
//       }
//     }
//     return handler.next(err);
//   }));
//   return dio;
// });

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final baseUrl = ref.read(baseUrlProvider);
  final authService = ref.watch(authServiceProvider.notifier);

  final client = Dio(
    BaseOptions(baseUrl: baseUrl, contentType: "application/json"),
  );
  client.interceptors
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
  client.interceptors.add(InterceptorsWrapper(onError: (err, handler) {
    if (err.response?.data?['error'] != null) {
      try {
        final backendExceptionData = BackendExceptionData.fromMap(
            err.response!.data?['error'] as Map<String, dynamic>);
        final backendException = BackendException(
            error: backendExceptionData, requestOptions: err.requestOptions);

        return handler.reject(backendException);
      } catch (ex) {
        return handler.next(err);
      }
    }
    return handler.next(err);
  }));
  return client;
}
