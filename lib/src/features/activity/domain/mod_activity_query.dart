import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/features/activity/domain/converter/activity_status_list_converter.dart';

part 'mod_activity_query.freezed.dart';
part 'mod_activity_query.g.dart';

@freezed
class ModActivityQuery with _$ModActivityQuery {
  @JsonSerializable(includeIfNull: false)
  factory ModActivityQuery({
    String? name,
    List<int>? skill,
    List<int>? org,
    @ActivityStatusListConverter() List<ActivityStatus>? status,
    @CommaSeparatedDateTimesConverter() List<DateTime>? startTime,
    @CommaSeparatedDateTimesConverter() List<DateTime>? endTime,
    String? locality,
    String? region,
    String? country,
    String? availableSlots,
    bool? isManager,
    bool? isShiftManager,
    int? limit,
    int? offset,
    @CommaSeparatedStringsConverter() List<String>? sort,
  }) = _ModActivityQuery;

  factory ModActivityQuery.fromJson(Map<String, dynamic> json) =>
      _$ModActivityQueryFromJson(json);
}
