import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class ActivityCardFooter extends StatelessWidget {
  final List<int> avatarIds;
  final int joinedParticipants;
  final int? maxParticipants;

  const ActivityCardFooter({
    super.key,
    required this.joinedParticipants,
    required this.avatarIds,
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
          child: AvatarStack(
            height: 36,
            avatars: avatarIds
                .map((avatarId) => Image.network(getImageUrl(avatarId)).image)
                .toList(),
          ),
        ),
        Text(slots),
      ],
    );
  }
}
