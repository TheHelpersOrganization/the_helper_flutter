import 'package:freezed_annotation/freezed_annotation.dart';

import '../../location/domain/location.dart';

part 'profile.g.dart';
part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  // @JsonSerializable(explicitToJson: true)
  factory Profile({
    String? username,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? gender,
    String? bio,
    DateTime? dateOfBirth,
    Location? location,
  }) = _Profile;
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

// class Profile {
//   Profile({
//     this.username,
//     this.phoneNumber,
//     this.firstName,
//     this.lastName,
//     this.gender,
//     this.bio,
//     this.dateOfBirth,
//     this.addressLine1,
//     this.addressLine2,
//   });

//   final String? username;

//   // final String imageUrl;
//   final String? phoneNumber;
//   final String? firstName;
//   final String? lastName;
//   final String? gender;
//   final String? bio;
//   final DateTime? dateOfBirth;
//   final String? addressLine1;
//   final String? addressLine2;

//   factory Profile.fromJson(Map<String, dynamic> data) {
//     final username = data['username'] as String?;
//     final phoneNumber = data['phoneNumber'] as String?;
//     final firstName = data['firstName'] as String?;
//     final lastName = data['lastName'] as String?;
//     final gender = data['gender'] as String?;
//     final bio = data['bio'] as String?;
//     final addressLine1 = data['addressLine1'] as String?;
//     final addressLine2 = data['addressLine2'] as String?;
//     DateTime? dateOfBirth;
//     final dateOfBirthData = data['dateOfBirth'];
//     if (dateOfBirthData == null) {
//       dateOfBirth = null;
//     } else if (dateOfBirthData is DateTime) {
//       dateOfBirth = dateOfBirthData;
//     } else {
//       dateOfBirth = DateTime.tryParse(dateOfBirthData);
//     }
//     return Profile(
//       username: username,
//       phoneNumber: phoneNumber,
//       firstName: firstName,
//       lastName: lastName,
//       gender: gender,
//       bio: bio,
//       dateOfBirth: dateOfBirth,
//       addressLine1: addressLine1,
//       addressLine2: addressLine2,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'username': username,
//       'phoneNumber': phoneNumber,
//       'firstName': firstName,
//       'lastName': lastName,
//       'gender': gender,
//       'bio': bio,
//       'dateOfBirth': dateOfBirth?.toIso8601String(),
//       'addressLine1': addressLine1,
//       'addressLine2': addressLine2,
//     };
//   }
// }