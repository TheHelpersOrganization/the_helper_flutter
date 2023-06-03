import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_ban.freezed.dart';
part 'account_ban.g.dart';

@freezed
class AccountBanModel with _$AccountBanModel {
  factory AccountBanModel({
    required int performedBy,
    @Default(true) bool isBanned,
    required String note,
    required DateTime createdAt,

  }) = _AccountBanModel;

  factory AccountBanModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBanModelFromJson(json);
}
