import 'dart:convert';

class ContactModel {
  final String name;
  final String? phoneNumber;
  final String? email;

  const ContactModel({
    required this.name,
    this.phoneNumber,
    this.email,
  });

  ContactModel copyWith({
    String? name,
    String? phoneNumber,
    String? email,
  }) {
    return ContactModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      name: map['name'] as String,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ContactModel(name: $name, phoneNumber: $phoneNumber, email: $email)';

  @override
  bool operator ==(covariant ContactModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ phoneNumber.hashCode ^ email.hashCode;
}
