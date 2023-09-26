import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';

part 'other_profile_org_controller.g.dart';

@riverpod
class ProfileOrganizationController extends _$ProfileOrganizationController {
  @override
  FutureOr<List<Organization>> build({required int id}) async {
    return _getJoinedOrganization(id);
  }

  Future<List<Organization>> _getJoinedOrganization(int id) async {
    final OrganizationRepository organizationRepository =
        ref.watch(organizationRepositoryProvider);
    final List<Organization> orgs = await organizationRepository
        .getOrgsQ(queryParameters: {'joinedAccount': id});
    return orgs;
  }
}