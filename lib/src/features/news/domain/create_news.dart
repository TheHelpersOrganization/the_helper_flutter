import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/news/domain/news.dart';

part 'create_news.freezed.dart';
part 'create_news.g.dart';

@freezed
class CreateNews with _$CreateNews {
  factory CreateNews({
    required NewsType type,
    required int organizationId,
    required String title,
    required String content,
    required NewsContentFormat contentFormat,
    int? thumbnail,
    required bool isPublished,
    int? activityId,
  }) = _CreateNews;

  factory CreateNews.fromJson(Map<String, dynamic> json) =>
      _$CreateNewsFromJson(json);
}
