import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_datetimes_converter.dart';

part 'activity_query.freezed.dart';
part 'activity_query.g.dart';

@freezed
class ActivityQuery with _$ActivityQuery {
  @JsonSerializable(includeIfNull: false)
  factory ActivityQuery({
    String? name,
    List<int>? skill,
    List<int>? org,
    @CommaSeparatedDateTimesConverter() List<DateTime>? startDate,
    @CommaSeparatedDateTimesConverter() List<DateTime>? endDate,
    String? locality,
    String? region,
    String? country,
    String? availableSlots,
    int? limit,
    int? offset,
  }) = _ActivityQuery;

  factory ActivityQuery.fromJson(Map<String, dynamic> json) =>
      _$ActivityQueryFromJson(json);
}
