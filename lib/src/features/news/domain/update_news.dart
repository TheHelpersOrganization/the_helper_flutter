import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/news/domain/news.dart';

part 'update_news.freezed.dart';
part 'update_news.g.dart';

@freezed
class UpdateNews with _$UpdateNews {
  @JsonSerializable(includeIfNull: false)
  factory UpdateNews({
    required NewsType type,
    String? title,
    String? content,
    NewsContentFormat? contentFormat,
    int? thumbnail,
    bool? isPublished,
    int? activityId,
  }) = _UpdateNews;

  factory UpdateNews.fromJson(Map<String, dynamic> json) =>
      _$UpdateNewsFromJson(json);
}
