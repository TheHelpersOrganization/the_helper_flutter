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
          isPublished: true,
          include: [NewsQueryInclude.author, NewsQueryInclude.organization],
          sort: NewsQuerySort.popularityDesc,
          limit: 10,
        ),
      ),
);

const defaultSort = NewsQuerySort.dateDesc;
final sortProvider = StateProvider.autoDispose<String>((ref) => defaultSort);

class NewsListPagedNotifier extends PagedNotifier<int, News> {
  final NewsRepository newsRepository;
  final String searchPattern;
  final String sort;

  NewsListPagedNotifier({
    required this.newsRepository,
    required this.searchPattern,
    required this.sort,
  }) : super(
          load: (page, limit) async {
            return newsRepository.getNews(
              query: NewsQuery(
                search: searchPattern.trim().isEmpty ? null : searchPattern,
                isPublished: true,
                include: [
                  //NewsQueryInclude.author,
                  NewsQueryInclude.organization
                ],
                sort: sort,
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
    final sort = ref.watch(sortProvider);

    return NewsListPagedNotifier(
      newsRepository: newsRepository,
      searchPattern: searchPattern,
      sort: sort,
    );
  },
);
