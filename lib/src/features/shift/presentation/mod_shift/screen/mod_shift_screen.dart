import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/controller/shift_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_contact.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_date_location.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_description.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_managers.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_participant.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_skill_list.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/widget/shift_title.dart';

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

    return Scaffold(
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
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Shift'),
                          content: const Text(
                              'Are you sure you want to delete this shift?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () {},
                              child: const Text('Delete'),
                            ),
                          ],
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
    );
  }
}
