import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_manager/activity_manager_list_tile.dart';
import 'package:the_helper/src/features/authentication/domain/account.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';

class SelectedManagers extends ConsumerWidget {
  final List<OrganizationMember> managers;
  final Account myAccount;
  final Set<int>? initialManagers;

  const SelectedManagers({
    super.key,
    required this.managers,
    required this.myAccount,
    this.initialManagers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedManagers =
        ref.watch(selectedManagerIdsProvider) ?? initialManagers;

    return selectedManagers?.isNotEmpty != true
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Selected managers',
                  style: context.theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ...selectedManagers?.map(
                    (selectedManager) {
                      final manager = managers.firstWhere(
                          (element) => selectedManager == element.accountId);

                      return ManagerListTile(
                        manager: manager,
                        isMyAccount: manager.accountId == myAccount.id,
                        onTap: () {
                          final value =
                              selectedManagers.contains(manager.accountId);
                          if (value == true) {
                            selectedManagers.remove(manager.accountId);
                            ref
                                .read(selectedManagerIdsProvider.notifier)
                                .state = {...selectedManagers};
                          } else {
                            ref
                                .read(selectedManagerIdsProvider.notifier)
                                .update((state) =>
                                    {...state ?? [], manager.accountId});
                          }
                        },
                        isChecked: selectedManagers.contains(manager.accountId),
                        onCheck: (value) {
                          if (value == true) {
                            ref
                                .read(selectedManagerIdsProvider.notifier)
                                .update((state) =>
                                    {...state ?? [], manager.accountId});
                          } else {
                            selectedManagers.remove(manager.accountId);
                            ref
                                .read(selectedManagerIdsProvider.notifier)
                                .state = {...selectedManagers};
                          }
                        },
                      );
                    },
                  ) ??
                  [],
              const SizedBox(height: 12),
            ],
          );
  }
}
