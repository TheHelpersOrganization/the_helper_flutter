import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';

part 'minimal_activity.freezed.dart';
part 'minimal_activity.g.dart';

@freezed
class MinimalActivity with _$MinimalActivity {
  @JsonSerializable(includeIfNull: false)
  factory MinimalActivity({
    required int id,
    required String name,
    int? thumbnail,
  }) = _MinimalActivity;

  factory MinimalActivity.fromJson(Map<String, dynamic> json) =>
      _$MinimalActivityFromJson(json);
}

extension ActivityX on Activity {
  MinimalActivity toMinimalActivity() => MinimalActivity(
        id: id!,
        name: name!,
        thumbnail: thumbnail,
      );
}
