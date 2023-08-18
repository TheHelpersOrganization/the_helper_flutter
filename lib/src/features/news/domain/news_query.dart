import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';
import 'package:the_helper/src/features/news/domain/converter/convert.dart';
import 'package:the_helper/src/features/news/domain/news.dart';

part 'news_query.freezed.dart';
part 'news_query.g.dart';

abstract class NewsQueryInclude {
  static const String author = 'author';
  static const String organization = 'organization';
  static const String reference = 'reference';
  static const List<String> all = [
    NewsQueryInclude.author,
    NewsQueryInclude.organization,
    NewsQueryInclude.reference,
  ];
}

abstract class NewsQuerySort {
  static const String relevanceAsc = 'relevance';
  static const String relevanceDesc = '-relevance';
  static const String popularityAsc = 'popularity';
  static const String popularityDesc = '-popularity';
  static const String dateAsc = 'date';
  static const String dateDesc = '-date';
  static const String viewsAsc = 'views';
  static const String viewsDesc = '-views';
}

@freezed
class NewsByIdQuery with _$NewsByIdQuery {
  @JsonSerializable(includeIfNull: false)
  factory NewsByIdQuery({
    @CommaSeparatedStringsConverter() List<String>? include,
  }) = _NewsByIdQuery;

  factory NewsByIdQuery.fromJson(Map<String, dynamic> json) =>
      _$NewsByIdQueryFromJson(json);
}

@freezed
class NewsQuery with _$NewsQuery {
  @JsonSerializable(includeIfNull: false)
  factory NewsQuery({
    @CommaSeparatedIntsConverter() List<int>? id,
    @NewsTypeListConverter() List<NewsType>? type,
    int? organizationId,
    int? authorId,
    String? search,
    int? thumbnail,
    bool? isPublished,
    @CommaSeparatedStringsConverter() List<String>? include,
    String? sort,
    int? limit,
    int? offset,
  }) = _NewsQuery;

  factory NewsQuery.fromJson(Map<String, dynamic> json) =>
      _$NewsQueryFromJson(json);
}
