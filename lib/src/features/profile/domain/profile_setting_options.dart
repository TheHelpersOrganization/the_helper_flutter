import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_setting_options.freezed.dart';

@freezed
class ProfileSettingOption with _$ProfileSettingOption {
  factory ProfileSettingOption({
    required String label,
    required bool optionState,
    @Default(false) bool isDisable,
    @Default(true) bool isTab,
  }) = _ProfileSettingOption;
}
