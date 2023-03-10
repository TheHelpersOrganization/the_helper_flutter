class Profile {
  Profile({
    required this.username,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.gender,
    this.bio,
    this.address,
  });
  final String? username;
  // final String imageUrl;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? bio;
  final String? address;
  factory Profile.fromJson(Map<String, dynamic> data) {
    final username = data['username'] as String?;
    final phoneNumber = data['telephoneNumber'] as String?;
    final firstName = data['firstName'] as String?;
    final lastName = data['lastName'] as String?;
    final gender = data['gender'] as String?;
    final bio = data['bio'] as String?;
    final address = data['address'] as String?;
    return Profile(
      username: username,
      phoneNumber: phoneNumber,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      bio: bio,
      address: address,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'telephoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'bio': bio,
      'address': address,
    };
  }
}
