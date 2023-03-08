import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/data/role_repository.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/domain/user_role.dart';

class HomeScreenController extends StateNotifier<UserRole> {
  HomeScreenController({required this.roleRepository})
      : super(const UserRole(isMod: false, isAdmin: false, role: 0));
  final UserRole roleRepository;

  Future<void> changeRole()
}
