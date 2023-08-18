import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/news/data/news_repository.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/domain/news_query.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';

final showSearchBoxProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
final searchPatternProvider = StateProvider.autoDispose((ref) => '');

final isPublishedFilterProvider =
    StateProvider.autoDispose<bool?>((ref) => null);
final newsTypeFilterProvider =
    StateProvider.autoDispose<Set<NewsType>>((ref) => {});
final sortProvider =
    StateProvider.autoDispose<String>((ref) => NewsQuerySort.dateDesc);

class OrganizationNewsListPagedNotifier extends PagedNotifier<int, News> {
  final AutoDisposeStateNotifierProviderRef ref;
  final NewsRepository newsRepository;
  final String searchPattern;
  final bool? isPublished;
  final Set<NewsType>? types;
  final String sort;

  OrganizationNewsListPagedNotifier({
    required this.ref,
    required this.newsRepository,
    required this.searchPattern,
    required this.isPublished,
    required this.types,
    required this.sort,
  }) : super(
          load: (page, limit) async {
            final organizationId = await ref
                .watch(currentOrganizationServiceProvider.notifier)
                .getCurrentOrganizationId();

            return newsRepository.getNews(
              query: NewsQuery(
                organizationId: organizationId,
                search: searchPattern.trim().isEmpty ? null : searchPattern,
                isPublished: isPublished,
                type: types?.toList(),
                include: [
                  NewsQueryInclude.author,
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

final organizationNewsListPagedNotifierProvider = StateNotifierProvider
    .autoDispose<OrganizationNewsListPagedNotifier, PagedState<int, News>>(
  (ref) {
    final newsRepository = ref.watch(newsRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final isPublished = ref.watch(isPublishedFilterProvider);
    final types = ref.watch(newsTypeFilterProvider);
    final sort = ref.watch(sortProvider);

    return OrganizationNewsListPagedNotifier(
      ref: ref,
      newsRepository: newsRepository,
      searchPattern: searchPattern,
      isPublished: isPublished,
      types: types,
      sort: sort,
    );
  },
);
