import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/review_dialog.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/volunteer_bottom_sheet.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class VolunteerListTile extends ConsumerWidget {
  final ShiftVolunteer volunteer;
  final ShiftStatus shiftStatus;
  const VolunteerListTile({
    required this.volunteer,
    required this.shiftStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = volunteer.profile!;
    final selectedVolunteer = ref.watch(selectedVolunteerProvider);
    final isSelected = selectedVolunteer.contains(volunteer);
    final isReviewed = volunteer.completion != 0 ||
        (volunteer.reviewNote != null && volunteer.reviewNote!.isNotEmpty);
    // Map<String, Color?> badges = {};
    List<Label> labels = [];
    if (shiftStatus == ShiftStatus.completed) {
      //todo: recheck condition
      if (isReviewed) {
        labels += [
          const Label(
            labelText: 'REVIEWED',
          )
        ];
      } else {
        labels += [
          Label(
            labelText: 'NOT REVIEWED',
            color: Theme.of(context).colorScheme.secondary,
          )
        ];
      }
      if (volunteer.isCheckInVerified ?? false) {
        labels += [
          const Label(
            labelText: 'VERIFIED CHECK-IN',
          ),
        ];
      } else {
        labels += [
          Label(
            labelText: 'UNVERIFIED CHECK-IN',
            color: Theme.of(context).colorScheme.secondary,
          ),
        ];
      }
      if (volunteer.isCheckOutVerified ?? false) {
        labels += [
          const Label(
            labelText: 'VERIFIED CHECK-OUT',
          ),
        ];
      } else {
        labels += [
          Label(
            labelText: 'UNVERIFIED CHECK-OUT',
            color: Theme.of(context).colorScheme.secondary,
          ),
        ];
      }

      //   badges += ['']
      // }
    } else {
      labels += [Label(labelText: volunteer.status.name.toUpperCase())];
    }
    if (shiftStatus == ShiftStatus.pending) {
      if (volunteer.meetSkillRequirements ?? false) {
        labels += [
          Label(
            labelText: 'SUITABLE',
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ];
      }
    }
    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.grey.shade200,
      leading: isSelected
          ? const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check_outlined,
                color: Colors.white,
              ),
            )
          : CircleAvatar(
              radius: 24,
              backgroundImage: getBackendImageOrLogoProvider(
                profile.avatarId,
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
      onLongPress: () => showModalBottomSheet(
        builder: (context) => VolunteerBottomSheet(
          volunteer: volunteer,
          // tab: tab,
          shiftStatus: shiftStatus,
        ),
        context: context,
        showDragHandle: true,
      ),
      onTap: () {
        if (isSelected) {
          ref.read(selectedVolunteerProvider.notifier).state = {
            ...selectedVolunteer..remove(volunteer)
          };
        } else {
          ref.read(selectedVolunteerProvider.notifier).state = {
            ...selectedVolunteer..add(volunteer)
          };
        }
      },
      isThreeLine: true,
      title: Text.rich(
        TextSpan(
          text: getProfileName(profile),
          children: labels
              .map(
                (label) => WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: label,
                  ),
                ),
              )
              .toList(),
        ),
      ),
      subtitle: SizedBox(
        height: 48.0,
        child: (profile.skills.isEmpty)
            ? const Text('No skills to show',
                style: TextStyle(fontStyle: FontStyle.italic))
            : ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...profile.skills.map(
                    (skill) {
                      if (skill.hours! > 0) {
                        return Chip(
                          labelPadding: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          avatar: const Icon(Icons.wb_sunny_outlined),
                          label: Text('${skill.name} - ${skill.hours}h'),
                        );
                      }
                    },
                  ).toList(),
                ].sizedBoxSpacing(
                  const SizedBox(
                    width: 8.0,
                  ),
                ),
              ),
      ),
      trailing: (shiftStatus == ShiftStatus.completed)
          ? ElevatedButton(
              child: const Icon(Icons.reviews_outlined),
              onPressed: () {
                ref.read(sliderValueProvider.notifier).state =
                    volunteer.completion;
                ref.read(textValueProvider.notifier).state =
                    volunteer.reviewNote ?? '';
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReviewDialog(
                      volunteer: volunteer,
                    );
                  },
                );
              },
            )
          : null,

      // trailing: Wrap(
      //   crossAxisAlignment: WrapCrossAlignment.center,
      //   spacing: 12.0,
      //   children: [
      //     ElevatedButton(
      //       child: const Icon(Icons.check),
      //       onPressed: () => null,
      //     ),
      //     ElevatedButton(
      //       child: const Icon(Icons.cancel),
      //       onPressed: () => null,
      //     ),
      //   ],
      // ),
    );
  }
}
