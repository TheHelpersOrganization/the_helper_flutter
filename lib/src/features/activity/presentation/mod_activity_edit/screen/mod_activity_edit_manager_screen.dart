import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/activity/domain/update_activity.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_manager/activity_manager_view.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_edit/controller/mod_activity_edit_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class ModActivityEditManagerScreen extends ConsumerWidget {
  final int activityId;

  const ModActivityEditManagerScreen({
    super.key,
    required this.activityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extendedActivityState = ref.watch(getActivityProvider(activityId));
    final activity = extendedActivityState.asData?.value;
    final updateState = ref.watch(updateActivityControllerProvider);
    final selectedManagers = ref.watch(selectedManagerIdsProvider);

    ref.listen<AsyncValue>(
      updateActivityControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Activity updated successfully'),
        );
      },
    );

    return LoadingOverlay(
      isLoading: updateState.isLoading,
      loadingOverlayType: LoadingOverlayType.custom,
      indicator: const LoadingDialog(
        titleText: 'Updating activity',
      ),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverAppBar(
              title: Text('Edit activity managers'),
              floating: true,
            ),
          ],
          body: extendedActivityState.when(
            skipLoadingOnRefresh: false,
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => CustomErrorWidget(
              onRetry: () => ref.invalidate(getActivityProvider),
            ),
            data: (data) {
              if (data == null) {
                return const DevelopingScreen();
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ActivityManagerView(
                    initialManagers: data.activityManagerIds?.toSet(),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: activity == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    height: 1,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            // Can skip skill step and manager step
                            child: TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text('Cancel'),
                            )),
                        Expanded(
                          flex: 3,
                          child: FilledButton(
                            onPressed: () {
                              final update = UpdateActivity(
                                activityManagerIds: selectedManagers?.toList(),
                              );
                              ref
                                  .read(
                                      updateActivityControllerProvider.notifier)
                                  .updateActivity(
                                    organizationId: activity.organizationId!,
                                    activityId: activityId,
                                    activity: update,
                                  );
                            },
                            child: const Text(
                              'Save',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
