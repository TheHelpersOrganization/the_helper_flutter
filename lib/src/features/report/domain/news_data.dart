import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/activity/domain/minimal_activity.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/organization/domain/minimal_organization.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

part 'news_data.freezed.dart';
part 'news_data.g.dart';

@freezed
class NewsData with _$NewsData {
  factory NewsData({
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
  }) = _NewsData;

  factory NewsData.fromJson(Map<String, dynamic> json) =>
      _$NewsDataFromJson(json);
}
