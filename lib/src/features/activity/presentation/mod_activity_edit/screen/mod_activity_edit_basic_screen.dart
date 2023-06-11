import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/activity/domain/update_activity.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_basic_view.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_edit/controller/mod_activity_edit_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

final formKey = GlobalKey<FormBuilderState>();

class ModActivityEditBasicScreen extends ConsumerWidget {
  final int activityId;

  const ModActivityEditBasicScreen({
    super.key,
    required this.activityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityState = ref.watch(getActivityProvider(activityId));
    final updateActivityState = ref.watch(updateActivityControllerProvider);

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
      isLoading: updateActivityState.isLoading,
      loadingOverlayType: LoadingOverlayType.custom,
      indicator: const LoadingDialog(
        titleText: 'Updating activity',
      ),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverAppBar(
              title: Text('Edit activity'),
              floating: true,
            ),
          ],
          body: activityState.when(
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
                  child: ActivityBasicView(
                    formKey: formKey,
                    initialActivity: data,
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: activityState.isLoading
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
                              if (!formKey.currentState!.saveAndValidate()) {
                                return;
                              }

                              final name =
                                  formKey.currentState!.fields['name']!.value;
                              final description = formKey
                                  .currentState!.fields['description']!.value;
                              final thumbnailValue = formKey
                                  .currentState!.fields['thumbnail']!.value;
                              Uint8List? thumbnail;
                              if (thumbnailValue != null) {
                                thumbnail =
                                    (thumbnailValue as List<dynamic>).isNotEmpty
                                        ? thumbnailValue[0]
                                        : null;
                              }

                              final update = UpdateActivity(
                                name: name,
                                description: description,
                              );
                              ref
                                  .read(
                                      updateActivityControllerProvider.notifier)
                                  .updateActivity(
                                    activityId: activityId,
                                    activity: update,
                                    thumbnailData: thumbnail,
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
