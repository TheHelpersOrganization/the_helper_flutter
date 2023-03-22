import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:the_helper/src/common/domain/contact.dart';
import 'package:the_helper/src/common/domain/location.dart';
import 'package:the_helper/src/common/typedef/image_id.dart';

part 'organization.g.dart';
part 'organization.freezed.dart';

@freezed
class Organization with _$Organization {
  factory Organization(
      List<Location> locations,
      List<Contact> contacts,
      {required String int,
      String? name,
      String? phoneNumber,
      String? email,
      String? description,
      String? website,
      ImageID? logo,
      ImageID? banner}) = _Organization;
}
