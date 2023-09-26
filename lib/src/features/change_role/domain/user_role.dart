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
  superadmin,
  operator,
  ;

  get isVolunteer => this == Role.volunteer;

  get isModerator => this == Role.moderator;

  get isAdmin => this == Role.admin;

  get isSuperAdmin => this == Role.superadmin;

  get isOperator => this == Role.operator;
}
