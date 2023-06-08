import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_shift_manager.freezed.dart';
part 'create_shift_manager.g.dart';

@freezed
class CreateShiftManager with _$CreateShiftManager {
  const factory CreateShiftManager({
    required int accountId,
    String? name,
    String? description,
  }) = _CreateShiftManager;

  factory CreateShiftManager.fromJson(Map<String, dynamic> json) =>
      _$CreateShiftManagerFromJson(json);
}
