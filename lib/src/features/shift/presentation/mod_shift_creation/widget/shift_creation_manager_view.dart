import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_manager_selection/shift_manager_selection_view.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/member.dart';

class ShiftCreationManagerView extends ConsumerWidget {
  final int activityId;
  final Set<int>? initialManagers;

  const ShiftCreationManagerView({
    super.key,
    required this.activityId,
    this.initialManagers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(getActivityProvider(activityId));
    final selectedManagers =
        ref.watch(selectedManagersProvider) ?? initialManagers;
    final shiftManagerDataState = ref.watch(memberDataProvider);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Shift Managers',
                style: context.theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ShiftManagerSelectionView(
                      initialManagers: initialManagers,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Manager'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        selectedManagers?.isNotEmpty != true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'No managers added',
                    style: context.theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap "+ Add Manager" to add skill or skip this step',
                    style:
                        TextStyle(color: context.theme.colorScheme.secondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : shiftManagerDataState.when(
                error: (_, __) => CustomErrorWidget(
                  onRetry: () => ref.invalidate(memberDataProvider),
                ),
                loading: () => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 48),
                    CircularProgressIndicator(),
                  ],
                ),
                data: (shiftManagerData) {
                  return Column(
                    children: selectedManagers?.map((data) {
                          final manager = shiftManagerData.managers.firstWhere(
                              (element) => element.accountId == data);
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(getMemberName(manager)),
                            subtitle:
                                manager.accountId == shiftManagerData.account.id
                                    ? const Text('Your account')
                                    : null,
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                getImageUrl(manager.profile!.avatarId!),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                              onPressed: () {
                                selectedManagers.remove(manager.accountId);
                                ref
                                    .read(selectedManagersProvider.notifier)
                                    .state = {...selectedManagers};
                              },
                            ),
                            minVerticalPadding: 16,
                          );
                        }).toList() ??
                        [],
                  );
                },
              )
      ],
    );
  }
}
