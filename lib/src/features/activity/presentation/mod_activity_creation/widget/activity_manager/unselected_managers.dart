import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/string.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_manager/activity_manager_list_tile.dart';
import 'package:the_helper/src/features/authentication/domain/account.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';

class UnselectedManagers extends ConsumerWidget {
  final List<OrganizationMember> managers;
  final Account myAccount;
  final Set<int>? initialManagers;
  final String? searchPattern;

  const UnselectedManagers({
    super.key,
    required this.managers,
    required this.myAccount,
    this.searchPattern,
    this.initialManagers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedManagers =
        ref.watch(selectedManagerIdsProvider) ?? initialManagers;

    final unselectedManagers = managers
        .where((manager) => (selectedManagers == null ||
            !selectedManagers.contains(manager.accountId)))
        .toList();
    if (searchPattern != null && searchPattern!.isNotEmpty) {
      unselectedManagers.retainWhere((manager) {
        return manager.profile?.lastName?.containsIgnoreCase(searchPattern!) ==
                true ||
            manager.profile?.firstName?.containsIgnoreCase(searchPattern!) ==
                true ||
            manager.profile?.username?.containsIgnoreCase(searchPattern!) ==
                true;
      });
    }
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
              if (selectedManagers != null &&
                  selectedManagers.contains(manager.accountId)) {
                final newSelectedManagers = {...selectedManagers};
                newSelectedManagers.remove(manager.accountId);
                ref.read(selectedManagerIdsProvider.notifier).state =
                    newSelectedManagers;
              } else {
                final Set<int> newSelectedManagers =
                    selectedManagers == null ? {} : {...selectedManagers};
                newSelectedManagers.add(manager.accountId);
                ref.read(selectedManagerIdsProvider.notifier).state =
                    newSelectedManagers;
              }
            },
            isChecked: selectedManagers != null &&
                selectedManagers.contains(manager.accountId),
            onCheck: (value) {
              if (value == true) {
                final Set<int> newSelectedManagers =
                    selectedManagers == null ? {} : {...selectedManagers};
                newSelectedManagers.add(manager.accountId);
                ref.read(selectedManagerIdsProvider.notifier).state =
                    newSelectedManagers;
              } else {
                if (selectedManagers == null) {
                  return;
                }
                selectedManagers.remove(manager.accountId);
                ref.read(selectedManagerIdsProvider.notifier).state = {
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
