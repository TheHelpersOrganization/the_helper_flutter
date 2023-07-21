import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';

import '../../../data/activity_repository.dart';
import '../../../domain/activity_query.dart';

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);

class ScrollPagingControlNotifier extends PagedNotifier<int, Activity> {
  final ActivityRepository activityRepository;
  final List<ActivityStatus> tabStatus;
  final String? searchPattern;

  ScrollPagingControlNotifier({
    required this.activityRepository,
    required this.tabStatus,
    this.searchPattern,
  }) : super(
          load: (page, limit) {
            return activityRepository.getActivities(
              query: ActivityQuery(
                limit: limit,
                offset: page * limit,
                name: searchPattern,
                status: tabStatus,
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final scrollPagingControlNotifier = StateNotifierProvider.autoDispose.family<
        ScrollPagingControlNotifier,
        PagedState<int, Activity>,
        List<ActivityStatus>>(
    (ref, index) => ScrollPagingControlNotifier(
        activityRepository: ref.watch(activityRepositoryProvider),
        tabStatus: index,
        searchPattern: ref.watch(searchPatternProvider)));
