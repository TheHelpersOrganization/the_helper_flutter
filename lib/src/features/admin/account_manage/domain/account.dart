import 'package:flutter/foundation.dart';

@immutable
class Account {
  final int id;
  final String name;
  final String email;
  final bool isAccountDisabled;
  final bool isAccountVerified;

  const Account({
    required this.id,
    required this.name,
    required this.email,
    required this.isAccountDisabled,
    required this.isAccountVerified,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          isAccountDisabled == other.isAccountDisabled &&
          isAccountVerified == other.isAccountVerified);

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      isAccountDisabled.hashCode ^
      isAccountVerified.hashCode;

  @override
  String toString() {
    return 'Account{ id: $id, email: $email, isAccountDisabled: $isAccountDisabled, isAccountVerified: $isAccountVerified,}';
  }

  Account copyWith({
    int? id,
    String? name,
    String? email,
    bool? isAccountDisabled,
    bool? isAccountVerified,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAccountDisabled: isAccountDisabled ?? this.isAccountDisabled,
      isAccountVerified: isAccountVerified ?? this.isAccountVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAccountDisabled': isAccountDisabled,
      'isAccountVerified': isAccountVerified,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      isAccountDisabled: map['isAccountDisabled'] as bool,
      isAccountVerified: map['isAccountVerified'] as bool,
    );
  }
}
