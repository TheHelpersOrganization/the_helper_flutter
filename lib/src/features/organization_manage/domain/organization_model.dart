import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../../location/domain/location.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_model.g.dart';
part 'organization_model.freezed.dart';

@freezed
class OrganizationModel with _$OrganizationModel {
  factory OrganizationModel({
    int? id,
    required String name,
    required String email,
    required String description,
  }) = _OrganizationModel;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
}
