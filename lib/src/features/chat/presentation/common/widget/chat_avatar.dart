import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ChatAvatar extends StatelessWidget {
  final Chat chat;
  final int myId;

  const ChatAvatar({
    super.key,
    required this.chat,
    required this.myId,
  });

  @override
  Widget build(BuildContext context) {
    final isGroup = chat.isGroup;
    final displayParticipants = chat.participants!
        .where((element) => element.id != myId)
        .take(4)
        .toList();

    if (!isGroup) {
      return getBackendCircleAvatarOrCharacter(
        displayParticipants.firstOrNull?.avatarId,
        getChatParticipantName(displayParticipants.firstOrNull)
            .characters
            .firstOrNull,
      );
    }

    final myParticipant = chat.participants!.firstWhere((e) => e.id == myId);
    if (displayParticipants.length < 4) {
      displayParticipants.add(myParticipant);
    }

    final avatarIds = displayParticipants.map((e) => e.avatarId).toList();
    final names = displayParticipants
        .map((e) => getChatParticipantName(e).characters.firstOrNull)
        .toList();

    final avatars = avatarIds
        .mapIndexed(
          (i, e) => getBackendCircleAvatarOrCharacter(
            e,
            names[i],
            radius: avatarIds.length == 1
                ? 20
                : avatarIds.length == 2
                    ? 13
                    : 10,
          ),
        )
        .toList();

    if (avatars.length == 2) {
      return SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: avatars[1],
            ),
            Positioned(
              bottom: 0,
              child: avatars[0],
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          Positioned(
            child: avatars[0],
          ),
          Positioned(
            right: 0,
            child: avatars[1],
          ),
          Positioned(
            bottom: 0,
            child: avatars[2],
          ),
          if (avatars.length == 4)
            Positioned(
              right: 0,
              bottom: 0,
              child: avatars[3],
            )
          else if (avatars.length > 4)
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.black.withOpacity(0.5),
                child: Text(
                  '+${avatars.length - 3}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
