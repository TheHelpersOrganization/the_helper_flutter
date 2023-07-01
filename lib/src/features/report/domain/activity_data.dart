
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_data.freezed.dart';
part 'activity_data.g.dart';

@freezed
class ActivityData with _$ActivityData {
  factory ActivityData({
    int? id,
    String? name,
    String? status,
    String? description,
    int? thumbnail,
    int? organizationId,
  }) = _ActivityData;

  factory ActivityData.fromJson(Map<String, dynamic> json) =>
      _$ActivityDataFromJson(json);
}
