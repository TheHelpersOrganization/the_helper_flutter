import 'package:freezed_annotation/freezed_annotation.dart';

import '../../location/domain/location.dart';
import '../../contact/domain/contact.dart';

part 'organization.g.dart';
part 'organization.freezed.dart';

@freezed
class Organization with _$Organization {
  factory Organization({
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
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}
