import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/organization/domain/minimal_organization.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

part 'news.freezed.dart';
part 'news.g.dart';

enum NewsContentFormat {
  plaintext,
  delta,
}

@freezed
class News with _$News {
  factory News({
    required int id,
    required int organizationId,
    MinimalOrganization? organization,
    required int authorId,
    Profile? author,
    required String title,
    required String content,
    required NewsContentFormat contentFormat,
    int? thumbnail,
    required int views,
    required bool isPublished,
    required DateTime publishedAt,
    required DateTime updatedAt,
  }) = _News;

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
}
