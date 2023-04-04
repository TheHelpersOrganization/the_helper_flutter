import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'organization_member_management_repository.g.dart';

class OrganizationMemberManagementRepository {
  final Dio client;

  OrganizationMemberManagementRepository({
    required this.client,
  });

  Future<OrganizationMember> get(int organizationId) async {
    final res = await client.get(
      '/organization/$organizationId/members',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> approve(int organizationId, int memberId) async {
    final res = await client.post(
      '/organization/$organizationId/members/$memberId/approve',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> reject(int organizationId, int memberId) async {
    final res = await client.post(
      '/organization/$organizationId/members/$memberId/reject',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> remove(int organizationId, int memberId) async {
    final res = await client.post(
      '/organization/$organizationId/members/$memberId/remove',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }
}

@riverpod
OrganizationMemberManagementRepository organizationMemberManagementRepository(
  OrganizationMemberManagementRepositoryRef ref,
) {
  return OrganizationMemberManagementRepository(client: ref.watch(dioProvider));
}
