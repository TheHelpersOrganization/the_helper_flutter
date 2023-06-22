import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/volunteer_bottom_sheet.dart';
import 'package:the_helper/src/utils/image.dart';

class VolunteerListTile extends ConsumerWidget {
  final ShiftVolunteer volunteer;
  final String tab;
  const VolunteerListTile({
    required this.tab,
    required this.volunteer,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = volunteer.profile!;
    print(volunteer.id);
    return InkWell(
      onTap: () => showModalBottomSheet(
        builder: (context) => VolunteerBottomSheet(
          volunteer: volunteer,
          tab: tab,
        ),
        context: context,
        showDragHandle: true,
      ),
      child: Card(
        child: ListTile(
          isThreeLine: true,
          title: Text('${profile.firstName!} ${profile.lastName!}'),
          subtitle: SizedBox(
            height: 48.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...profile.skills
                    .map(
                      (skill) => Chip(
                        labelPadding: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        avatar: const Icon(Icons.wb_sunny_outlined),
                        label: Text('${skill.name} - ${skill.hours}'),
                      ),
                    )
                    .toList(),
              ].sizedBoxSpacing(
                const SizedBox(
                  width: 8.0,
                ),
              ),
            ),
          ),
          leading: CircleAvatar(
            radius: 24,
            backgroundImage: getBackendImageOrLogoProvider(
              profile.avatarId,
            ),
            // backgroundImage: ImageX.backend(
            //   profile.avatarId!,
            //   loadingBuilder: (context, child, loadingProgress) =>
            //       loadingProgress == null
            //           ? child
            //           : const CircularProgressIndicator(),
            // ).image,
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          // onChanged: (bool? value) {},
          // value: false,
          // trailing: Box,
        ),
      ),
    );
  }
}
