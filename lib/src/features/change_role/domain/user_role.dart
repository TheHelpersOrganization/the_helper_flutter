import 'dart:ffi';

class UserRole {
  final bool isMod;
  final bool isAdmin;
  final int? role;

  const UserRole({
    required this.isMod,
    required this.isAdmin,
    this.role,
  });

  factory UserRole.fromJson(Map<String, dynamic> data) {
    final isMod = data['isMod'] as bool;
    final isAdmin = data['isAdmin'] as bool;
    return UserRole(
      isMod: isMod,
      isAdmin: isAdmin,
    );
  }
}
