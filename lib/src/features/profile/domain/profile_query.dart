import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';

part 'profile_query.freezed.dart';
part 'profile_query.g.dart';

class ProfileQueryInclude {
  static const String interestedSkills = 'interested-skills';
  static const String skills = 'skills';
}

class ProfileQuerySelect {
  static const String username = 'username';
  static const String fullName = 'full-name';
  static const String avatar = 'avatar';
}

@freezed
class ProfileQuery with _$ProfileQuery {
  @JsonSerializable(includeIfNull: false)
  factory ProfileQuery({
    @CommaSeparatedStringsConverter() List<String>? ids,
    @CommaSeparatedStringsConverter() List<String>? includes,
    @CommaSeparatedStringsConverter() List<String>? select,
  }) = _ProfileQuery;
  factory ProfileQuery.fromJson(Map<String, dynamic> json) =>
      _$ProfileQueryFromJson(json);
}
