import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/features/activity/domain/converter/activity_status_list_converter.dart';

part 'activity_query.freezed.dart';
part 'activity_query.g.dart';

class ActivityQuerySort {
  static const String nameAsc = 'name';
  static const String nameDesc = '-name';
  static const String startTimeAsc = 'startTime';
  static const String startTimeDesc = '-startTime';
  static const String endTimeAsc = 'endTime';
  static const String endTimeDesc = '-endTime';
}

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
    @ActivityStatusListConverter() List<ActivityStatus>? status,
    bool? isManager,
    bool? isShiftManager,
    int? limit,
    int? offset,
    @CommaSeparatedStringsConverter() List<String>? sort,
  }) = _ActivityQuery;

  factory ActivityQuery.fromJson(Map<String, dynamic> json) =>
      _$ActivityQueryFromJson(json);
}
