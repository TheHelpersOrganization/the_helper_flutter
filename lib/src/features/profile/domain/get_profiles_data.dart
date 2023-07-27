import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';

part 'get_profiles_data.freezed.dart';
part 'get_profiles_data.g.dart';

@freezed
class GetProfilesData with _$GetProfilesData {
  @JsonSerializable(includeIfNull: false)
  factory GetProfilesData({
    @CommaSeparatedIntsConverter() List<int>? ids,
  }) = _GetProfilesData;

  factory GetProfilesData.fromJson(Map<String, dynamic> json) =>
      _$GetProfilesDataFromJson(json);
}
