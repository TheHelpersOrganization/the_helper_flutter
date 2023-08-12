import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/role_controller.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_controller.dart';

class ChangeRoleData {
  final List<Role> roles;
  final Role? currentRole;
  final List<Organization> joinedOrganizations;
  final Organization? currentOrganization;

  const ChangeRoleData({
    required this.roles,
    required this.currentRole,
    required this.joinedOrganizations,
    required this.currentOrganization,
  });
}

final changeRoleDataProvider = FutureProvider.autoDispose((ref) async {
  final roles = (await ref.watch(authServiceProvider.future))!.account.roles;
  final currentRole = await ref.watch(setRoleControllerProvider.future);
  final joinedOrganizations =
      await ref.watch(joinedOrganizationProvider.future);
  final currentOrganization =
      await ref.watch(currentOrganizationServiceProvider.future);

  return ChangeRoleData(
    roles: roles,
    currentRole: currentRole,
    joinedOrganizations: joinedOrganizations,
    currentOrganization: currentOrganization,
  );
});
