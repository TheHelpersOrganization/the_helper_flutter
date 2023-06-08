import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/member.dart';

class ManagerListTile extends StatelessWidget {
  final OrganizationMember manager;
  final bool isMyAccount;
  final VoidCallback? onTap;
  final bool isChecked;
  final void Function(bool?)? onCheck;
  final EdgeInsetsGeometry? contentPadding;

  const ManagerListTile({
    super.key,
    required this.manager,
    required this.isMyAccount,
    this.onTap,
    required this.isChecked,
    this.onCheck,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(getMemberName(manager)),
      subtitle: isMyAccount ? const Text('Your account') : null,
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          getImageUrl(manager.profile!.avatarId!),
        ),
      ),
      onTap: onTap,
      trailing: Checkbox(
        value: isChecked,
        onChanged: onCheck,
      ),
      minVerticalPadding: 16,
      contentPadding: contentPadding,
    );
  }
}
