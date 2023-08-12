import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/news/presentation/news/screen/news_screen.dart';
import 'package:the_helper/src/features/news/presentation/news_create/screen/news_create_screen.dart';
import 'package:the_helper/src/features/news/presentation/news_list/screen/news_list_screen.dart';
import 'package:the_helper/src/features/news/presentation/organization_news_list/screen/organization_news_list_screen.dart';
import 'package:the_helper/src/router/router.dart';

final newsRoutes = [
  GoRoute(
    path: AppRoute.news.path,
    name: AppRoute.news.name,
    builder: (context, state) => const NewsListScreen(),
    routes: [
      GoRoute(
        path: AppRoute.newsDetail.path,
        name: AppRoute.newsDetail.name,
        builder: (context, state) {
          final newsId =
              int.parse(state.pathParameters[AppRouteParameter.newsId]!);

          return NewsScreen(
            newsId: newsId,
          );
        },
      ),
    ],
  ),
  GoRoute(
    path: AppRoute.organizationNews.path,
    name: AppRoute.organizationNews.name,
    builder: (context, state) => const OrganizationNewsListScreen(),
    routes: [
      GoRoute(
        path: AppRoute.organizationNewsCreate.path,
        name: AppRoute.organizationNewsCreate.name,
        builder: (context, state) => const NewsCreateScreen(),
      ),
    ],
  ),
];
