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
    @CommaSeparatedIntsConverter() List<int>? skill,
    @CommaSeparatedIntsConverter() List<int>? org,
    @CommaSeparatedDateTimesConverter() List<DateTime?>? startTime,
    @CommaSeparatedDateTimesConverter() List<DateTime?>? endTime,
    String? locality,
    String? region,
    String? country,
    double? lat,
    double? lng,
    double? radius,
    String? availableSlots,
    @ActivityStatusListConverter() List<ActivityStatus>? status,
    bool? isManager,
    bool? isShiftManager,
    int? limit,
    int? offset,
    int? cursor,
    @CommaSeparatedStringsConverter() List<String>? sort,
  }) = _ActivityQuery;

  factory ActivityQuery.fromJson(Map<String, dynamic> json) =>
      _$ActivityQueryFromJson(json);
}
