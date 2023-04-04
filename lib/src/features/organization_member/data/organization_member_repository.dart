import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
      '/organization/$organizationId/members',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> join(int organizationId) async {
    final res = await client.post(
      '/organization/$organizationId/members/join',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  // Cancel Join
  Future<OrganizationMember> cancel(int organizationId) async {
    final res = await client.post(
      '/organization/$organizationId/members/cancel',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }

  Future<OrganizationMember> leave(int organizationId) async {
    final res = await client.post(
      '/organization/$organizationId/members/leave',
    );
    return OrganizationMember.fromJson(res.data['data']);
  }
}

@riverpod
OrganizationMemberRepository organizationMemberRepository(
  OrganizationMemberRepositoryRef ref,
) {
  return OrganizationMemberRepository(client: ref.watch(dioProvider));
}
