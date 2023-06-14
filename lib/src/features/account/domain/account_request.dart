import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../../../common/domain/file_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_request.g.dart';
part 'account_request.freezed.dart';

@freezed
class AccountRequestModel with _$AccountRequestModel {
  factory AccountRequestModel({
    int? accountId,
    required String status,
    int? performedBy,
    @Default(true) bool isVerified,
    String? note,
    required DateTime createdAt,
    List<FileInfoModel>? files,
  }) = _AccountRequestModel;

  factory AccountRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestModelFromJson(json);
}
