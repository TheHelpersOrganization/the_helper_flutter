import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/news/presentation/news/screen/news_screen.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/news_create_controller.dart';
import 'package:the_helper/src/features/news/presentation/news_create/screen/news_create_screen.dart';
import 'package:the_helper/src/features/news/presentation/news_list/screen/news_list_screen.dart';
import 'package:the_helper/src/router/router.dart';

final newsRoutes = GoRoute(
  path: AppRoute.news.path,
  name: AppRoute.news.name,
  builder: (context, state) => const NewsListScreen(),
  routes: [
    GoRoute(
      path: AppRoute.newsCreate.path,
      name: AppRoute.newsCreate.name,
      builder: (context, state) => NewsCreateScreen(
        mode: NewsUpdateMode.create,
      ),
    ),
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
        routes: [
          GoRoute(
            path: AppRoute.newsUpdate.path,
            name: AppRoute.newsUpdate.name,
            builder: (context, state) => NewsCreateScreen(
              mode: NewsUpdateMode.update,
              initialValue:
                  int.parse(state.pathParameters[AppRouteParameter.newsId]!),
            ),
          ),
        ]),
  ],
);
