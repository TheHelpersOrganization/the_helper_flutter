import 'package:freezed_annotation/freezed_annotation.dart';

part 'verified_request.freezed.dart';
part 'verified_request.g.dart';

@freezed
class VerifiedRequest with _$VerifiedRequest {
  @JsonSerializable(includeIfNull: false)
  factory VerifiedRequest({
    int? id,
    DateTime? requestDate,
    List<int>? files,
  }) = _VerifiedRequest;
  factory VerifiedRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifiedRequestFromJson(json);
}
