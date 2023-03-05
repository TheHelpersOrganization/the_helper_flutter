import 'package:dio/dio.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/auth_service.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(contentType: "application/json"),
  );
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final _auth = ref.read(authServiceProvider).valueOrNull;
    options.connectTimeout = const Duration(seconds: 3000);
    options.receiveTimeout = const Duration(seconds: 3000);
    String? access = _auth?.token.access;
    String? refresh = _auth?.token.refresh;
    if (access == null || refresh == null) return handler.next(options);
    options.headers['Authorization'] = "Bearer $access";
  }));
  return dio;
}
