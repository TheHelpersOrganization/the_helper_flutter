import 'package:flutter/material.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

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
      title: Text(getProfileName(manager.profile)),
      subtitle: isMyAccount ? const Text('Your account') : null,
      leading: CircleAvatar(
        backgroundImage: getBackendImageOrLogoProvider(
          manager.profile?.avatarId,
        ),
      ),
      onTap: onTap,
      trailing: isChecked
          ? IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            )
          : TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.add_outlined),
              label: const Text('Add'),
            ),
      minVerticalPadding: 16,
      contentPadding: contentPadding,
    );
  }
}
