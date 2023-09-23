import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_ints_converter.dart';
import 'package:the_helper/src/common/converter/comma_separated_strings_converter.dart';

part 'activity_volunteer_query.freezed.dart';
part 'activity_volunteer_query.g.dart';

class ActivityVolunteerQueryInclude {
  static const String profile = 'profile';
}

@freezed
class ActivityVolunteerQuery with _$ActivityVolunteerQuery {
  @JsonSerializable(includeIfNull: false)
  factory ActivityVolunteerQuery({
    @NonNullCommaSeparatedIntsConverter() required List<int> activityId,
    @CommaSeparatedStringsConverter() List<String>? include,
    int? limitPerActivity,
  }) = _ActivityVolunteerQuery;

  factory ActivityVolunteerQuery.fromJson(Map<String, dynamic> json) =>
      _$ActivityVolunteerQueryFromJson(json);
}
