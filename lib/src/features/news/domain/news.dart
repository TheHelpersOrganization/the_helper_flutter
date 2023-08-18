import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/activity/domain/minimal_activity.dart';
import 'package:the_helper/src/features/organization/domain/minimal_organization.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

part 'news.freezed.dart';
part 'news.g.dart';

enum NewsType {
  general,
  activity,
}

enum NewsContentFormat {
  plaintext,
  delta,
}

@freezed
class News with _$News {
  factory News({
    required int id,
    required NewsType type,
    required int organizationId,
    MinimalOrganization? organization,
    required int authorId,
    Profile? author,
    required String title,
    required String content,
    required NewsContentFormat contentFormat,
    int? thumbnail,
    required int views,
    required int popularity,
    required bool isPublished,
    required DateTime publishedAt,
    required DateTime updatedAt,
    int? activityId,
    MinimalActivity? activity,
  }) = _News;

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
}
