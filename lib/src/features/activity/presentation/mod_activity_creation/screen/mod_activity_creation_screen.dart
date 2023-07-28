import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/custom_sliver_scroll_view.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_basic_view.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_contact/activity_contact_view.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_manager/activity_manager_view.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
import 'package:the_helper/src/utils/step.dart';

final _formKey = GlobalKey<FormBuilderState>();

class ModActivityCreationScreen extends ConsumerWidget {
  const ModActivityCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityManagersState = ref.watch(activityManagersProvider);
    final activityManagerSelection = ref.watch(selectedManagersProvider);
    final createActivityState = ref.watch(createActivityControllerProvider);
    final currentStep = ref.watch(currentStepProvider);
    final steps = [
      StepView(
        title: const Text('Basic'),
        content: ActivityBasicView(formKey: _formKey),
      ),
      const StepView(
        title: Text('Contacts'),
        content: ActivityContactView(),
      ),
      const StepView(
        title: Text('Managers'),
        content: ActivityManagerView(),
      ),
    ];
    final isLastPage = currentStep == steps.length - 1;
    final selectedContacts = ref.watch(selectedContactsProvider);

    ref.listen<AsyncValue>(
      createActivityControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
      },
    );

    return LoadingOverlay(
      loadingOverlayType: LoadingOverlayType.custom,
      opacity: 0.8,
      isLoading: createActivityState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Creating activity',
      ),
      child: Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    // Can skip skill step and manager step
                    child: currentStep == 0
                        ? TextButton(
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.goNamed(AppRoute
                                    .organizationActivityListManagement.name);
                              }
                            },
                            child: const Text('Cancel'),
                          )
                        : TextButton(
                            onPressed: () {
                              ref.read(currentStepProvider.notifier).state =
                                  currentStep - 1;
                            },
                            child: const Text('Back'),
                          ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FilledButton(
                      onPressed: () {
                        if (!_formKey.currentState!.saveAndValidate()) {
                          return;
                        }

                        if (!isLastPage) {
                          ref.read(currentStepProvider.notifier).state =
                              currentStep + 1;
                          return;
                        }

                        final name =
                            _formKey.currentState!.fields['name']!.value;
                        final description =
                            _formKey.currentState!.fields['description']!.value;
                        final thumbnailValue =
                            _formKey.currentState!.fields['thumbnail']!.value;
                        Uint8List? thumbnail;
                        if (thumbnailValue != null) {
                          thumbnail =
                              (thumbnailValue as List<dynamic>).isNotEmpty
                                  ? thumbnailValue[0]
                                  : null;
                        }

                        ref
                            .read(createActivityControllerProvider.notifier)
                            .createActivity(
                              name: name,
                              description: description,
                              thumbnailData: thumbnail,
                              activityManagerIds:
                                  activityManagerSelection?.toList(),
                              contacts: selectedContacts,
                            );
                      },
                      child: Text(isLastPage ? 'Create' : 'Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: CustomSliverScrollView(
          appBar: CustomSliverAppBar(
            titleText: 'Create Activity',
            showBackButton: true,
            onBackFallback: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRoute.home.name);
              }
            },
            actions: const [],
          ),
          body: Stepper(
            margin: EdgeInsets.zero,
            type: StepperType.horizontal,
            currentStep: currentStep,
            controlsBuilder: (context, details) => const SizedBox.shrink(),
            steps: createSteps(
              steps: steps,
              currentStep: currentStep,
            ),
          ),
        ),
      ),
    );
  }
}
