import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_detail.freezed.dart';
part 'error_detail.g.dart';

@freezed
class ErrorDetail with _$ErrorDetail {
  const factory ErrorDetail({
    int? statusCode,
    String? message,
    String? localizedMessage,
    String? errorName,
    String? details,
  }) = _ErrorDetail;
  factory ErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailFromJson(json);
}
