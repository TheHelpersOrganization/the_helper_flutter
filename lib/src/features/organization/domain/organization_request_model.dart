import 'package:flutter/foundation.dart';
import 'package:the_helper/src/features/location/domain/location.dart';

import '../../contact/domain/contact.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_request_model.g.dart';
part 'organization_request_model.freezed.dart';

@freezed
class OrganizationRequestModel with _$OrganizationRequestModel {
  factory OrganizationRequestModel({
    int? id,
    required String name,
    required String email,
    required String phoneNumber,
    required String description,
    required String website,
    int? logo,
    int? banner,
    List<Location>? locations,
    List<int>? files,
    List<Contact>? contacts,
  }) = _OrganizationModel;

  factory OrganizationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationRequestModelFromJson(json);
}
