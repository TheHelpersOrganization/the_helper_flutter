import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

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
          : Text(name.characters.first.toUpperCase()),
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundImage: CachedNetworkImageProvider(
      getImageUrl(imageId),
    ),
  );
}

ImageProvider getLogoProvider() {
  return Image.asset('assets/images/logo.png').image;
}
