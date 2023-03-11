import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rawDioProvider =
    Provider((ref) => Dio(BaseOptions(contentType: Headers.jsonContentType)));
