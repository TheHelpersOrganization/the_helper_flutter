import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_manager/activity_manager_selection_view.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ActivityManagerView extends ConsumerWidget {
  final Set<int>? initialManagers;

  const ActivityManagerView({
    super.key,
    this.initialManagers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityManagersState = ref.watch(activityManagersProvider);
    final selectedManagers =
        ref.watch(selectedManagersProvider) ?? initialManagers;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activity Managers',
              style: context.theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActivityManagerSelectionView(
                      initialManagers: initialManagers,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Manager'),
            )
          ],
        ),
        if (selectedManagers != null && selectedManagers.isNotEmpty)
          activityManagersState.when(
            skipLoadingOnRefresh: false,
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (_, __) => CustomErrorWidget(
              onRetry: () {
                ref.invalidate(activityManagersProvider);
              },
            ),
            data: (data) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: selectedManagers.length,
                itemBuilder: (context, index) {
                  final manager = data.managers.firstWhere((element) =>
                      element.accountId == selectedManagers.elementAt(index));

                  return ListTile(
                    title: Text(getProfileName(manager.profile)),
                    subtitle: manager.accountId == data.account.id
                        ? const Text('Your account')
                        : null,
                    leading: CircleAvatar(
                      backgroundImage: getBackendImageOrLogoProvider(
                        manager.profile?.avatarId,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      onPressed: () {
                        selectedManagers.remove(manager.accountId);
                        ref.read(selectedManagersProvider.notifier).state = {
                          ...selectedManagers
                        };
                      },
                    ),
                    minVerticalPadding: 16,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              );
            },
          )
        else
          Column(
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
                style: TextStyle(color: context.theme.colorScheme.secondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }
}
