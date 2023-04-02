import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.g.dart';
part 'account.freezed.dart';

@freezed
class AccountModel with _$AccountModel {
  factory AccountModel({
    int? id,
    required String name,
    required String email,
    @Default(false) bool isAccountDisabled,
    @Default(false) bool isAccountVerified,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}
// @immutable
// class AccountModel {
//   final int id;
//   final String name;
//   final String email;
//   final bool isAccountDisabled;
//   final bool isAccountVerified;

//   const AccountModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.isAccountDisabled,
//     required this.isAccountVerified,
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is AccountModel &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           email == other.email &&
//           isAccountDisabled == other.isAccountDisabled &&
//           isAccountVerified == other.isAccountVerified);

//   @override
//   int get hashCode =>
//       id.hashCode ^
//       email.hashCode ^
//       isAccountDisabled.hashCode ^
//       isAccountVerified.hashCode;

//   @override
//   String toString() {
//     return 'AccountModel{ id: $id, email: $email, isAccountDisabled: $isAccountDisabled, isAccountVerified: $isAccountVerified,}';
//   }

//   AccountModel copyWith({
//     int? id,
//     String? name,
//     String? email,
//     bool? isAccountDisabled,
//     bool? isAccountVerified,
//   }) {
//     return AccountModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       isAccountDisabled: isAccountDisabled ?? this.isAccountDisabled,
//       isAccountVerified: isAccountVerified ?? this.isAccountVerified,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'isAccountDisabled': isAccountDisabled,
//       'isAccountVerified': isAccountVerified,
//     };
//   }

//   factory AccountModel.fromMap(Map<String, dynamic> map) {
//     return AccountModel(
//       id: map['id'] as int,
//       name: map['name'] as String,
//       email: map['email'] as String,
//       isAccountDisabled: map['isAccountDisabled'] as bool,
//       isAccountVerified: map['isAccountVerified'] as bool,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory AccountModel.fromJson(String source) =>
//       AccountModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }
