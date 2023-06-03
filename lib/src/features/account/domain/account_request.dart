import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../../location/domain/location.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_request.g.dart';
part 'account_request.freezed.dart';

@freezed
class AccountRequestModel with _$AccountRequestModel {
  factory AccountRequestModel({
    int? id,
    required String name,
    required String email,
    required DateTime time,
    List<Location>? locations,
  }) = _AccountRequestModel;

  factory AccountRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestModelFromJson(json);
}
