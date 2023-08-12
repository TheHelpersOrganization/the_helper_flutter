import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/news/data/news_repository.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/domain/news_query.dart';

final searchPatternProvider = StateProvider.autoDispose((ref) => '');
final showSearchBoxProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final popularNewsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(newsRepositoryProvider).getNews(
        query: NewsQuery(
          include: [NewsQueryInclude.author, NewsQueryInclude.organization],
          sort: NewsQuerySort.popularityDesc,
          limit: 10,
        ),
      ),
);

class NewsListPagedNotifier extends PagedNotifier<int, News> {
  final NewsRepository newsRepository;
  final String searchPattern;

  NewsListPagedNotifier({
    required this.newsRepository,
    required this.searchPattern,
  }) : super(
          load: (page, limit) async {
            return newsRepository.getNews(
              query: NewsQuery(
                search: searchPattern.trim().isEmpty ? null : searchPattern,
                include: [
                  //NewsQueryInclude.author,
                  NewsQueryInclude.organization
                ],
                sort: NewsQuerySort.dateDesc,
                limit: limit,
                offset: page * limit,
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final newsListPagedNotifierProvider = StateNotifierProvider.autoDispose<
    NewsListPagedNotifier, PagedState<int, News>>(
  (ref) {
    final newsRepository = ref.watch(newsRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);

    return NewsListPagedNotifier(
      newsRepository: newsRepository,
      searchPattern: searchPattern,
    );
  },
);
