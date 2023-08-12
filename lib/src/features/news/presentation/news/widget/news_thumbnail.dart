import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class NewsThumbnail extends StatelessWidget {
  final News news;

  const NewsThumbnail({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: context.mediaQuery.size.width / 16 * 9,
        child: news.thumbnail == null
            ? SvgPicture.asset('assets/images/news_placeholder.svg')
            : CachedNetworkImage(
                imageUrl: getImageUrl(news.thumbnail!),
                width: context.mediaQuery.size.width,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
