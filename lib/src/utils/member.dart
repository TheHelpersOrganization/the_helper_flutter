import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';

String getMemberName(OrganizationMember member) {
  String memberName = member.profile?.username ??
      member.account?.email ??
      member.accountId.toString();
  return memberName;
}
