import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_manager.freezed.dart';
part 'shift_manager.g.dart';

@freezed
class ShiftManager with _$ShiftManager {
  const factory ShiftManager({
    required int accountId,
    // required int accountId,
    String? name,
    String? description,
  }) = _ShiftManager;
  factory ShiftManager.fromJson(Map<String, dynamic> json) =>
      _$ShiftManagerFromJson(json);
}
