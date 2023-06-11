import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

part 'shift_manager.freezed.dart';
part 'shift_manager.g.dart';

@freezed
class ShiftManager with _$ShiftManager {
  const factory ShiftManager({
    required int accountId,
    String? name,
    String? description,
    Profile? profile,
  }) = _ShiftManager;

  factory ShiftManager.fromJson(Map<String, dynamic> json) =>
      _$ShiftManagerFromJson(json);
}
