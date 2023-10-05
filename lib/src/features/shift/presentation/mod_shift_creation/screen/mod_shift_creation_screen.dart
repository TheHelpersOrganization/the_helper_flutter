import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/shift/domain/create_shift.dart';
import 'package:the_helper/src/features/shift/domain/create_shift_manager.dart';
import 'package:the_helper/src/features/shift/domain/create_shift_skill.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_creation_basic_view.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_creation_contact_view.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_creation_manager_view.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_creation_skill_view.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

final _formKey = GlobalKey<FormBuilderState>();
const stepCount = 4;

class ModShiftCreationScreen extends ConsumerWidget {
  final int activityId;

  const ModShiftCreationScreen({
    super.key,
    required this.activityId,
  });

  List<Step> getSteps(
    int currentStep, {
    required Activity activity,
  }) {
    int index = 0;
    final steps = [
      createStep(
        currentStep: currentStep,
        index: index++,
        title: 'Basic',
        content: ShiftCreationBasicView(
          formKey: _formKey,
          activityId: activityId,
          activity: activity,
        ),
      ),
      createStep(
        currentStep: currentStep,
        index: index++,
        title: 'Contacts',
        content: const ShiftCreationContactView(),
      ),
      createStep(
        currentStep: currentStep,
        index: index++,
        title: 'Skills',
        content: ShiftCreationSkillView(
          activityId: activityId,
        ),
      ),
      createStep(
        currentStep: currentStep,
        index: index++,
        title: 'Managers',
        content: ShiftCreationManagerView(
          activityId: activityId,
        ),
      ),
    ];
    if (stepCount != steps.length) {
      throw Exception('maxSteps != steps.length');
    }
    return steps;
  }

  Step createStep({
    required int currentStep,
    required int index,
    required String title,
    required Widget content,
  }) =>
      Step(
        title: currentStep == index ? Text(title) : const Text(''),
        state: currentStep > index ? StepState.complete : StepState.indexed,
        isActive: currentStep >= index,
        content: content,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isParticipantLimited = ref.watch(isParticipantLimitedProvider);
    final createShiftState = ref.watch(createShiftControllerProvider);
    final currentStep = ref.watch(currentStepProvider);
    final selectedSkill = ref.watch(selectedSkillsProvider);
    final selectedManagers = ref.watch(selectedManagersProvider);
    final selectedContacts = ref.watch(selectedContactIdsProvider);
    final PlaceDetails? place = ref.watch(placeProvider);
    final activityAndMembersState =
        ref.watch(activityAndMembersProvider(activityId));

    // Preload skills for skills step
    ref.watch(getSkillsProvider);

    ref.listen<AsyncValue>(
      createShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
      },
    );

    return LoadingOverlay(
      loadingOverlayType: LoadingOverlayType.custom,
      opacity: 0.8,
      isLoading: createShiftState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Creating shift',
      ),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const CustomSliverAppBar(
              titleText: 'Create Shift',
              actions: [],
            )
          ],
          body: activityAndMembersState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            data: (data) {
              final steps = getSteps(currentStep, activity: data.activity);
              return Stepper(
                margin: EdgeInsets.zero,
                type: StepperType.horizontal,
                currentStep: currentStep,
                steps: steps,
                controlsBuilder: (context, details) => const SizedBox.shrink(),
              );
            },
          ),
        ),
        bottomNavigationBar: activityAndMembersState.maybeWhen(
          data: (data) => Column(
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
                      child: currentStep == 0
                          ? TextButton(
                              onPressed: () {
                                context.pop();
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
                          final isLastPage = currentStep == stepCount - 1;

                          if (!_formKey.currentState!.saveAndValidate()) {
                            return;
                          }

                          if (!isLastPage) {
                            ref.read(currentStepProvider.notifier).state =
                                currentStep + 1;
                            return;
                          }

                          final String name =
                              _formKey.currentState!.fields['name']!.value;
                          final String description = _formKey
                              .currentState!.fields['description']!.value;
                          final Location? location = place?.toLocation();
                          final String locationString =
                              _formKey.currentState!.fields['location']!.value;
                          final int? numberOfParticipants = _formKey
                                      .currentState!
                                      .fields['isParticipantLimited']!
                                      .value ==
                                  true
                              ? int.parse(_formKey.currentState!
                                  .fields['numberOfParticipants']!.value)
                              : null;
                          final DateTime startTime =
                              _formKey.currentState!.fields['startTime']!.value;
                          final DateTime endTime =
                              _formKey.currentState!.fields['endTime']!.value;

                          final shift = CreateShift(
                            activityId: activityId,
                            name: name,
                            description: description,
                            startTime: startTime,
                            endTime: endTime,
                            numberOfParticipants: numberOfParticipants,
                            locations: [
                              location ??
                                  Location(addressLine1: locationString),
                            ],
                            contacts: selectedContacts?.toList(),
                            shiftSkills: selectedSkill
                                ?.map(
                                  (e) => CreateShiftSkill(
                                    skillId: e.skill!.id,
                                    hours: e.hours,
                                  ),
                                )
                                .toList(),
                            shiftManagers: selectedManagers
                                ?.map(
                                  (e) => CreateShiftManager(accountId: e),
                                )
                                .toList(),
                          );
                          ref
                              .read(createShiftControllerProvider.notifier)
                              .createShift(shift: shift);
                        },
                        child: Text(
                          currentStep == stepCount - 1 ? 'Create' : 'Next',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          orElse: () => null,
        ),
      ),
    );
  }
}
