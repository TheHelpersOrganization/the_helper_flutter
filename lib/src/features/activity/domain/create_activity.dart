import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/location/domain/location.dart';

part 'create_activity.freezed.dart';
part 'create_activity.g.dart';

@freezed
class CreateActivity with _$CreateActivity {
  @JsonSerializable(includeIfNull: false)
  factory CreateActivity({
    required String name,
    String? description,
    int? thumbnail,
    List<int>? activityManagerIds,
    required Location location,
    List<int>? contacts,
  }) = _CreateActivity;

  factory CreateActivity.fromJson(Map<String, dynamic> json) =>
      _$CreateActivityFromJson(json);
}
