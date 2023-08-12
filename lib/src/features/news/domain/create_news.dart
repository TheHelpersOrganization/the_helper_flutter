import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_news.freezed.dart';
part 'create_news.g.dart';

@freezed
class CreateNews with _$CreateNews {
  factory CreateNews({
    required int organizationId,
    required String title,
    required String content,
    int? thumbnail,
    required bool isPublished,
  }) = _CreateNews;

  factory CreateNews.fromJson(Map<String, dynamic> json) =>
      _$CreateNewsFromJson(json);
}
