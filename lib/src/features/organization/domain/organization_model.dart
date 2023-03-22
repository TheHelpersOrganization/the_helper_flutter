// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:the_helper/src/features/contact/domain/contact_model.dart';

import '../../location/domain/location_model.dart';

class OrganizationModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String description;
  final String website;
  final int? logo;
  final int? banner;
  final List<LocationModel>? locations;
  final List<int>? files;
  final List<ContactModel>? contacts;

  OrganizationModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.description,
    required this.website,
    this.logo,
    this.banner,
    this.locations,
    this.files,
    this.contacts,
  });

  OrganizationModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? description,
    String? website,
    int? logo,
    int? banner,
    List<LocationModel>? locations,
    List<int>? files,
    List<ContactModel>? contacts,
  }) {
    return OrganizationModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      website: website ?? this.website,
      logo: logo ?? this.logo,
      banner: banner ?? this.banner,
      locations: locations ?? this.locations,
      files: files ?? this.files,
      contacts: contacts ?? this.contacts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'description': description,
      'website': website,
      'logo': logo,
      'banner': banner,
      'locations': locations?.map((x) => x.toMap()).toList(),
      'files': files,
      'contacts': contacts?.map((x) => x.toMap()).toList(),
    };
  }

  factory OrganizationModel.fromMap(Map<String, dynamic> map) {
    return OrganizationModel(
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      description: map['description'] as String,
      website: map['website'] as String,
      logo: map['logo'] != null ? map['logo'] as int : null,
      banner: map['banner'] != null ? map['banner'] as int : null,
      locations: map['locations'] != null
          ? List<LocationModel>.from(
              (map['locations'] as List<dynamic>).map<LocationModel?>(
                (x) => LocationModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      files: map['files'] != null
          ? List<int>.from((map['files'] as List<int>))
          : null,
      contacts: map['contacts'] != null
          ? List<ContactModel>.from(
              (map['contacts'] as List<dynamic>).map<ContactModel?>(
                (x) => ContactModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrganizationModel.fromJson(String source) =>
      OrganizationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrganizationModel(name: $name, email: $email, phoneNumber: $phoneNumber, description: $description, website: $website, logo: $logo, banner: $banner, locations: $locations, files: $files, contacts: $contacts)';
  }

  @override
  bool operator ==(covariant OrganizationModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.description == description &&
        other.website == website &&
        other.logo == logo &&
        other.banner == banner &&
        listEquals(other.locations, locations) &&
        listEquals(other.files, files) &&
        listEquals(other.contacts, contacts);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        description.hashCode ^
        website.hashCode ^
        logo.hashCode ^
        banner.hashCode ^
        locations.hashCode ^
        files.hashCode ^
        contacts.hashCode;
  }
}
