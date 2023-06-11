import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

part 'update_activity.freezed.dart';
part 'update_activity.g.dart';

@freezed
class UpdateActivity with _$UpdateActivity {
  @JsonSerializable(includeIfNull: false)
  factory UpdateActivity({
    String? name,
    String? description,
    int? thumbnail,
    List<int>? activityManagerIds,
    List<Contact>? contacts,
  }) = _UpdateActivity;

  factory UpdateActivity.fromJson(Map<String, dynamic> json) =>
      _$UpdateActivityFromJson(json);
}
