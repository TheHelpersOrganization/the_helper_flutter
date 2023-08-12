import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_news.freezed.dart';
part 'update_news.g.dart';

@freezed
class UpdateNews with _$UpdateNews {
  @JsonSerializable(includeIfNull: false)
  factory UpdateNews({
    String? title,
    String? content,
    int? thumbnail,
    bool? isPublished,
  }) = _UpdateNews;

  factory UpdateNews.fromJson(Map<String, dynamic> json) =>
      _$UpdateNewsFromJson(json);
}
