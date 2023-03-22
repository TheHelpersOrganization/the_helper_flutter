import 'package:dio/dio.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';

extension DioX on Dio {
  Future<Response<T>> getOrCatch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    try {
      return get(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
    } on BackendException catch (ex) {
      return Future.error(ex);
    }
  }
}
