
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_data.freezed.dart';
part 'account_data.g.dart';

@freezed
class AccountData with _$AccountData {
  factory AccountData({
    int? id,
    required String username,
    String? firstName,
    String? lastName,
    int? avatarId,
    required String email,
  }) = _AccountData;

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);
}
