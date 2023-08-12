import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/news/data/news_repository.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/domain/news_query.dart';

final quillControllerProvider =
    ChangeNotifierProvider.autoDispose<QuillController>(
  (ref) => QuillController.basic(),
);

final newsProvider = FutureProvider.autoDispose.family<News, int>(
  (ref, id) => ref.watch(newsRepositoryProvider).getNewsById(
        id: id,
        query: NewsByIdQuery(include: [
          NewsQueryInclude.author,
          NewsQueryInclude.organization,
        ]),
      ),
);
