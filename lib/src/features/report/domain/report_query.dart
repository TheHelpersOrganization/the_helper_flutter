import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_datetimes_converter.dart';

part 'report_query.freezed.dart';
part 'report_query.g.dart';

@freezed
class ReportQuery with _$ReportQuery {
  @JsonSerializable(includeIfNull: false)
  factory ReportQuery({
    String? email,
    String? type,
    bool? isSolved,
    @IntListConverter() List<int>? ids,
    @CommaSeparatedDateTimesConverter() List<DateTime>? ct,
    int? limit,
    int? offset,
  }) = _ReportQuery;

  factory ReportQuery.fromJson(Map<String, dynamic> json) =>
      _$ReportQueryFromJson(json);
}

class IntListConverter implements JsonConverter<List<int>?, String?> {
  const IntListConverter();

  @override
  fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return json.split(',').map((e) => int.parse(e)).toList();
  }

  @override
  toJson(List<int>? object) {
    if (object == null) {
      return null;
    }
    return object.join(',');
  }
}
