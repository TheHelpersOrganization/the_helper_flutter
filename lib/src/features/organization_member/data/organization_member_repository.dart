import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization/domain/organization_member_role.dart';
import 'package:the_helper/src/features/organization_member/domain/get_organization_member_query.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'organization_member_repository.g.dart';

class OrganizationMemberRepository {
  final Dio client;

  OrganizationMemberRepository({
    required this.client,
  });

  Future<OrganizationMember> get(int organizationId) async {
    final res = await client.get(
      '/organizations/$organizationId/members',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> getMe({
    required int organizationId,
    GetOrganizationMemberQuery? query,
  }) async {
    final res = await client.get(
      '/organizations/$organizationId/members/me',
      queryParameters: query?.toJson(),
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> getMemberById({
    required int organizationId,
    required int memberId,
    GetOrganizationMemberQuery? query,
  }) async {
    final res = await client.get(
      '/organizations/$organizationId/members/$memberId',
      queryParameters: query?.toJson(),
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> join(int organizationId) async {
    final res = await client.post(
      '/organizations/$organizationId/members/join',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  // Cancel Join
  Future<OrganizationMember> cancel(int organizationId) async {
    final res = await client.post(
      '/organizations/$organizationId/members/cancel',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> leave(int organizationId) async {
    final res = await client.post(
      '/organizations/$organizationId/members/leave',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<MemberRoleInfo> getMemberRoleInfo({
    required int organizationId,
    required int memberId,
  }) async {
    final res = await client
        .get('/organizations/$organizationId/members/$memberId/roles');
    final data = res.data['data'];
    return MemberRoleInfo.fromJson(data);
  }

  Future<void> grantRole({
    required int organizationId,
    required int memberId,
    required OrganizationMemberRoleType role,
  }) async {
    await client.post(
      '/organizations/$organizationId/members/$memberId/roles/grant',
      data: {
        'role': role.name,
      },
    );
  }

  Future<void> revokeRole({
    required int organizationId,
    required int memberId,
    required OrganizationMemberRoleType role,
  }) async {
    await client.post(
      '/organizations/$organizationId/members/$memberId/roles/revoke',
      data: {
        'role': role.name,
      },
    );
  }
}

@riverpod
OrganizationMemberRepository organizationMemberRepository(
  OrganizationMemberRepositoryRef ref,
) {
  return OrganizationMemberRepository(client: ref.watch(dioProvider));
}
