import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';

part 'profile_organization_controller.g.dart';

@riverpod
class ProfileOrganizationController extends _$ProfileOrganizationController {
  @override
  FutureOr<List<Organization>> build() async {
    return _getJoinedOrganization();
  }

  Future<List<Organization>> _getJoinedOrganization() async {
    final OrganizationRepository organizationRepository =
        ref.watch(organizationRepositoryProvider);
    final List<Organization> orgs = await organizationRepository
        .getOrgsQ(queryParameters: {'joined': true});
    return orgs;
  }
}
