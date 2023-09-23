import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity_me.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/location/domain/location.dart';

part 'activity_analytic_model.g.dart';
part 'activity_analytic_model.freezed.dart';

@freezed
class ActivityAnalyticModel with _$ActivityAnalyticModel {
  @JsonSerializable(includeIfNull: false)
  factory ActivityAnalyticModel({
    int? id,
    String? name,
    bool? isDisabled,
    ActivityStatus? status,
    String? description,
    int? thumbnail,
    int? organizationId,
    List<int>? skillIds,
    List<int>? activityManagerIds,
    DateTime? startTime,
    DateTime? endTime,
    Location? location,
    List<Contact>? contacts,
    @Default(0) double? rating,
    @Default(0) int? ratingCount,
    int? maxParticipants,
    @Default(0) int? joinedParticipants,
    ActivityMe? me,
    int? organizationLogo,
    String? organizationName
  }) = _ActivityAnalyticModel;

  factory ActivityAnalyticModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityAnalyticModelFromJson(json);
}
