import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/data/account_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/get_organization_member_query.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/organization_member/domain/reject_member_data.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'mod_organization_member_repository.g.dart';

class ModOrganizationMemberRepository {
  final Dio client;
  final AccountRepository accountRepository;
  final ProfileRepository profileRepository;

  ModOrganizationMemberRepository({
    required this.client,
    required this.accountRepository,
    required this.profileRepository,
  });

  Future<List<OrganizationMember>> getMemberWithAccountProfile(
    int organizationId, {
    GetOrganizationMemberQuery? query,
  }) async {
    final updatedQuery = query != null
        ? query.copyWith(
            include: [
              GetOrganizationMemberQueryInclude.profile,
              GetOrganizationMemberQueryInclude.contact,
              GetOrganizationMemberQueryInclude.role,
            ],
          )
        : GetOrganizationMemberQuery(
            include: [
              GetOrganizationMemberQueryInclude.profile,
              GetOrganizationMemberQueryInclude.contact,
              GetOrganizationMemberQueryInclude.role,
            ],
          );
    final List<dynamic> res = (await client.get(
      '/mod/organizations/$organizationId/members',
      queryParameters: updatedQuery.toJson(),
    ))
        .data['data'];
    final List<OrganizationMember> members =
        res.map((e) => OrganizationMember.fromJson(e)).toList();
    // final accountIds = members.map((e) => e.accountId).toList();

    // final profiles = await profileRepository.getProfiles(
    //   GetProfilesData(ids: accountIds),
    // );

    // final List<OrganizationMember> result = [];
    // for (final member in members) {
    //   final profile = profiles.cast<Profile?>().firstWhere(
    //         (e) => e!.id == member.accountId,
    //         orElse: () => null,
    //       );
    //   result.add(member.copyWith(
    //     profile: profile,
    //   ));
    // }
    return members;
  }

  Future<OrganizationMember> approve({
    required int organizationId,
    required int memberId,
  }) async {
    final res = await client.post(
      '/mod/organizations/$organizationId/members/$memberId/approve',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> approveBack({
    required int organizationId,
    required int memberId,
  }) async {
    final res = await client.post(
      '/mod/organizations/$organizationId/members/$memberId/approve-back',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> reject({
    required int organizationId,
    required int memberId,
    RejectMemberData? data,
  }) async {
    final res = await client.post(
      '/mod/organizations/$organizationId/members/$memberId/reject',
      data: data?.toJson(),
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> remove({
    required int organizationId,
    required int memberId,
  }) async {
    final res = await client.post(
      '/mod/organizations/$organizationId/members/$memberId/remove',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }
}

@riverpod
ModOrganizationMemberRepository modOrganizationMemberRepository(
  ModOrganizationMemberRepositoryRef ref,
) {
  return ModOrganizationMemberRepository(
    client: ref.watch(dioProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
    accountRepository: ref.watch(accountRepositoryProvider),
  );
}
