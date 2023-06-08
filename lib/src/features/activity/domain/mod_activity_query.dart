import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_datetimes_converter.dart';

part 'mod_activity_query.freezed.dart';
part 'mod_activity_query.g.dart';

@freezed
class ModActivityQuery with _$ModActivityQuery {
  @JsonSerializable(includeIfNull: false)
  factory ModActivityQuery({
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
  }) = _ModActivityQuery;

  factory ModActivityQuery.fromJson(Map<String, dynamic> json) =>
      _$ModActivityQueryFromJson(json);
}
