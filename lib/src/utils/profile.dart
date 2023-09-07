import 'package:the_helper/src/features/chat/domain/chat_participant.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

String getProfileName(Profile? profile, {bool? singularName}) {
  if (profile == null) {
    return 'Unknown Name';
  }
  if (singularName != true &&
      profile.firstName != null &&
      profile.lastName != null) {
    return '${profile.firstName} ${profile.lastName}';
  } else if (profile.lastName != null) {
    return profile.lastName!;
  } else if (profile.firstName != null) {
    return profile.firstName!;
  }
  String name = profile.username ??
      profile.email ??
      profile.id?.toString() ??
      'Unknown Name';
  return name;
}

String getChatParticipantName(ChatParticipant? profile, {bool? singularName}) {
  if (profile == null) {
    return 'Unknown Name';
  }
  // if (singularName != true &&
  //     profile.firstName != null &&
  //     profile.lastName != null) {
  //   return '${profile.firstName} ${profile.lastName}';
  // } else if (profile.lastName != null) {
  //   return profile.lastName!;
  // } else if (singularName != true && profile.firstName != null) {
  //   return profile.firstName!;
  // }
  if (profile.lastName != null) {
    if (singularName == true) {
      return profile.lastName!;
    }
    return '${profile.firstName ?? ''} ${profile.lastName}';
  }
  String name = profile.username ?? profile.email;
  return name;
}

List<Profile> matchProfiles(Iterable<Profile> profiles, String pattern) {
  final List<Profile> res = [];
  final lowercasedPattern = pattern.toLowerCase();
  for (final profile in profiles) {
    if (profile.firstName?.toLowerCase().contains(lowercasedPattern) == true ||
        profile.lastName?.toLowerCase().contains(lowercasedPattern) == true ||
        profile.username?.toLowerCase().contains(lowercasedPattern) == true ||
        profile.email?.toLowerCase().contains(lowercasedPattern) == true ||
        profile.phoneNumber?.toLowerCase().contains(lowercasedPattern) ==
            true) {
      res.add(profile);
    }
  }
  return res;
}
