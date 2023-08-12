import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/news/domain/create_news.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/domain/news_query.dart';
import 'package:the_helper/src/features/news/domain/update_news.dart';
import 'package:the_helper/src/utils/dio.dart';

class NewsRepository {
  final Dio client;

  NewsRepository({
    required this.client,
  });

  Future<List<News>> getNews({NewsQuery? query}) async {
    final res = await client.get(
      '/news',
      queryParameters: query?.toJson(),
    );
    final List<dynamic> resListData = res.data['data'];
    return resListData.map((e) => News.fromJson(e)).toList();
  }

  Future<News> getNewsById({
    required int id,
    NewsByIdQuery? query,
  }) async {
    final res = await client.get(
      '/news/$id',
      queryParameters: query?.toJson(),
    );
    return News.fromJson(res.data['data']);
  }

  Future<News> createNews({required CreateNews data}) async {
    final res = await client.post('/news', data: data.toJson());
    return News.fromJson(res.data['data']);
  }

  Future<News> updateNews({
    required int id,
    required UpdateNews data,
  }) async {
    final res = await client.put('/news/$id', data: data.toJson());
    return News.fromJson(res.data['data']);
  }

  Future<News> deleteNews({required int id}) async {
    final res = await client.delete('/news/$id');
    return News.fromJson(res.data['data']);
  }
}

final newsRepositoryProvider = Provider.autoDispose<NewsRepository>((ref) {
  final client = ref.watch(dioProvider);
  return NewsRepository(client: client);
});
