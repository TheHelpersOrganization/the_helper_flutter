import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/features/chat/domain/chat_participant.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/profile.dart';

ImageProvider getBackendImageOrLogoProvider(int? imageId) {
  if (imageId == null) {
    return Image.asset('assets/images/logo.png').image;
  }
  return CachedNetworkImageProvider(
    getImageUrl(imageId),
  );
}

CircleAvatar getBackendCircleAvatarOrCharacter(int? imageId, String? name,
    {double? radius}) {
  if (imageId == null) {
    return CircleAvatar(
      radius: radius,
      child: name == null || name.isEmpty
          ? null
          : Text(
              name.characters.first.toUpperCase(),
              style: radius == null ? null : TextStyle(fontSize: radius),
            ),
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundImage: CachedNetworkImageProvider(
      getImageUrl(imageId),
    ),
  );
}

CircleAvatar getBackendCircleAvatarOrCharacterFromProfile(Profile profile,
    {double? radius}) {
  return getBackendCircleAvatarOrCharacter(
    profile.avatarId,
    getProfileName(profile),
    radius: radius,
  );
}

CircleAvatar getBackendCircleAvatarOrCharacterFromChatParticipant(
    ChatParticipant chatParticipant,
    {double? radius}) {
  return getBackendCircleAvatarOrCharacter(
    chatParticipant.avatarId,
    getChatParticipantName(chatParticipant),
    radius: radius,
  );
}

ImageProvider getLogoProvider() {
  return Image.asset('assets/images/logo.png').image;
}
