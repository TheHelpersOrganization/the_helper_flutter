import 'package:flutter/foundation.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

import '../../../common/domain/file_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_request_query.dart';

part 'account_request.g.dart';
part 'account_request.freezed.dart';

@freezed
class AccountRequestModel with _$AccountRequestModel {
  factory AccountRequestModel({
    int? id,
    int? accountId,
    AccountRequestStatus? status,
    int? performedBy,
    @Default(true) bool isVerified,
    String? note,
    Profile? profile,
    required DateTime createdAt,
    @Default([]) List<FileInfoModel> files,
  }) = _AccountRequestModel;

  factory AccountRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestModelFromJson(json);
}
