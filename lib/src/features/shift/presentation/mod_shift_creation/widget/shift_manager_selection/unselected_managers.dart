import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/authentication/domain/account.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_manager_selection/shift_manager_list_tile.dart';

class UnselectedManagers extends ConsumerWidget {
  final Set<int> selectedManagers;
  final List<OrganizationMember> managers;
  final Account myAccount;

  const UnselectedManagers({
    super.key,
    required this.selectedManagers,
    required this.managers,
    required this.myAccount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unselectedManagers = managers
        .where((manager) => !selectedManagers.contains(manager.accountId))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            'Your organization members',
            style: context.theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ...unselectedManagers.map(
          (manager) => ManagerListTile(
            manager: manager,
            isMyAccount: manager.accountId == myAccount.id,
            onTap: () {
              final value = selectedManagers.contains(manager.accountId);
              if (value == true) {
                selectedManagers.remove(manager.accountId);
                ref.read(selectedManagersProvider.notifier).state = {
                  ...selectedManagers
                };
              } else {
                ref
                    .read(selectedManagersProvider.notifier)
                    .update((state) => {...state, manager.accountId});
              }
            },
            isChecked: selectedManagers.contains(manager.accountId),
            onCheck: (value) {
              if (value == true) {
                ref
                    .read(selectedManagersProvider.notifier)
                    .update((state) => {...state, manager.accountId});
              } else {
                selectedManagers.remove(manager.accountId);
                ref.read(selectedManagersProvider.notifier).state = {
                  ...selectedManagers
                };
              }
            },
          ),
        ),
      ],
    );
  }
}
