import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/controller/shift_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/delete_shift_dialog.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_contact.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_date_location.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_description.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_managers.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_participant.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_skill_list.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_title.dart';
import 'package:the_helper/src/router/router.dart';

class ModShiftScreen extends ConsumerWidget {
  final int activityId;
  final int shiftId;

  const ModShiftScreen({
    super.key,
    required this.activityId,
    required this.shiftId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAndShiftState = ref.watch(getActivityAndShiftProvider(
      shiftId,
    ));
    final deleteShiftState = ref.watch(deleteShiftControllerProvider);

    return LoadingOverlay(
      isLoading: deleteShiftState.isLoading,
      loadingOverlayType: LoadingOverlayType.custom,
      indicator: const LoadingDialog(
        titleText: 'Deleting shift',
      ),
      child: Scaffold(
        body: activityAndShiftState.when(
          skipLoadingOnRefresh: false,
          error: (_, __) => CustomErrorWidget(
            onRetry: () => ref.invalidate(getActivityAndShiftProvider),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          data: (activityAndShift) {
            if (activityAndShift == null ||
                activityAndShift.activity.id != activityId) {
              return const DevelopingScreen();
            }
            final activity = activityAndShift.activity;
            final shift = activityAndShift.shift;

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: const Text('Shift'),
                  floating: true,
                  actions: [
                    PopupMenuButton(
                      tooltip: 'Edit shift content',
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text('Edit basic info'),
                            onTap: () => context.pushNamed(
                              AppRoute.shiftEdit.name,
                              pathParameters: {
                                'activityId': activityId.toString(),
                                'shiftId': shiftId.toString(),
                              },
                            ),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text('Edit skills'),
                            onTap: () => context.pushNamed(
                              AppRoute.shiftEditSkills.name,
                              pathParameters: {
                                'activityId': activityId.toString(),
                                'shiftId': shiftId.toString(),
                              },
                            ),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text('Edit contacts'),
                            onTap: () => context.pushNamed(
                              AppRoute.shiftEditContacts.name,
                              pathParameters: {
                                'activityId': activityId.toString(),
                                'shiftId': shiftId.toString(),
                              },
                            ),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text('Edit managers'),
                            onTap: () => context.pushNamed(
                              AppRoute.shiftEditManagers.name,
                              pathParameters: {
                                'activityId': activityId.toString(),
                                'shiftId': shiftId.toString(),
                              },
                            ),
                          ),
                        ];
                      },
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          useRootNavigator: false,
                          builder: (context) => DeleteShiftDialog(
                            activityId: activityId,
                            shiftId: shiftId,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShiftTitle(activity: activity, shift: shift),
                      const SizedBox(
                        height: 24,
                      ),
                      ShiftDescription(
                        description: shift.description,
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      ShiftParticipant(
                        joinedParticipants: shift.joinedParticipants,
                        numberOfParticipants: shift.numberOfParticipants,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ShiftDateLocation(
                        startTime: shift.startTime,
                        endTime: shift.endTime,
                        location: shift.locations?.isNotEmpty == true
                            ? shift.locations?.first
                            : null,
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      ShiftSkillList(
                        skills: shift.shiftSkills,
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      ShiftContact(contacts: shift.contacts),
                      const SizedBox(
                        height: 48,
                      ),
                      ShiftManagers(
                        managers: shift.shiftManagers,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
