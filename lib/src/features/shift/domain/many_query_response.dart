import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/shift/domain/error_response.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

part 'many_query_response.freezed.dart';
part 'many_query_response.g.dart';

@freezed
class ManyQueryResponse with _$ManyQueryResponse {
  const factory ManyQueryResponse({
    required List<ShiftVolunteer?> success,
    required List<ErrorResponse?> error,
  }) = _ManyQueryResponse;
  factory ManyQueryResponse.fromJson(Map<String, dynamic> json) =>
      _$ManyQueryResponseFromJson(json);
}