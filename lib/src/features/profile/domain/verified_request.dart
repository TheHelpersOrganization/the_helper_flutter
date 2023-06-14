import 'package:freezed_annotation/freezed_annotation.dart';

part 'verified_request.freezed.dart';
part 'verified_request.g.dart';

@freezed
class VerifiedRequestBody with _$VerifiedRequestBody {
  @JsonSerializable(includeIfNull: false)
  factory VerifiedRequestBody({
    String? content,
    List<int>? files,
  }) = _VerifiedRequest;
  factory VerifiedRequestBody.fromJson(Map<String, dynamic> json) =>
      _$VerifiedRequestBodyFromJson(json);
}
