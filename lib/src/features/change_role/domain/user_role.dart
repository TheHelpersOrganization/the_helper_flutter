class UserRole {
  final bool isMod;
  final bool isAdmin;
  final int role;

  const UserRole({
    required this.isMod,
    required this.isAdmin,
    required this.role,
  });

  factory UserRole.fromJson(Map<String, dynamic> data) {
    final isMod = data['isMod'] as bool;
    final isAdmin = data['isAdmin'] as bool;
    return UserRole(isMod: isMod, isAdmin: isAdmin, role: 0);
  }
}

enum Role {
  volunteer,
  moderator,
  admin,
  operator,
}
