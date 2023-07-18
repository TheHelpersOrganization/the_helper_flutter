import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class ActivityCardFooter extends StatelessWidget {
  final List<ActivityVolunteer>? volunteers;
  final int joinedParticipants;
  final int? maxParticipants;

  const ActivityCardFooter({
    super.key,
    required this.joinedParticipants,
    this.volunteers,
    this.maxParticipants,
  });

  @override
  Widget build(BuildContext context) {
    String slots = joinedParticipants.toString();
    if (maxParticipants != null) {
      slots += '/$maxParticipants';
      slots += ' Slots';
    } else {
      slots += ' Participants';
    }
    return Row(
      children: [
        Expanded(
          child: volunteers == null
              ? const SizedBox(
                  height: 36,
                )
              : CustomAvatarStack(volunteers: volunteers!),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(slots),
        ),
      ],
    );
  }
}

class CustomAvatarStack extends StatelessWidget {
  final List<ActivityVolunteer> volunteers;
  const CustomAvatarStack({
    super.key,
    required this.volunteers,
  });

  @override
  Widget build(BuildContext context) {
    List<int?> avatarIds = volunteers
        .map(
          (e) => e.profile!.avatarId,
        )
        .toList();
    return AvatarStack(
      height: 36,
      avatars: avatarIds
          .map((avatarId) => avatarId == null
              ? Image.asset('assets/images/logo.png').image
              : Image.network(getImageUrl(avatarId)).image)
          .toList(),
    );
  }
}
