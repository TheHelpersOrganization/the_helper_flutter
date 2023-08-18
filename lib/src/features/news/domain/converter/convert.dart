import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/news/domain/news.dart';

class NewsTypeListConverter extends JsonConverter<List<NewsType>?, String?> {
  const NewsTypeListConverter();

  @override
  List<NewsType>? fromJson(String? json) {
    return json
        ?.split(',')
        .map(
          (e) => NewsType.values.firstWhere(
            (element) => element.name == e,
          ),
        )
        .toList();
  }

  @override
  String? toJson(List<NewsType>? object) {
    return object?.map((e) => e.name).join(',');
  }
}
