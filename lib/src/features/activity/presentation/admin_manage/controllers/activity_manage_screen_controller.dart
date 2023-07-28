import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/skill/data/skill_repository.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';
import 'package:the_helper/src/utils/async_value.dart';

import '../../../data/activity_repository.dart';
import '../../../domain/activity_query.dart';

class ActivityManageScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}

  Future<Activity?> ban(int id) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() =>
        ref.watch(activityRepositoryProvider).banActivity(activityId: id));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<Activity?> unban(int id) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() =>
        ref.watch(activityRepositoryProvider).unbanActivity(activityId: id));
    state = const AsyncData(null);
    return res.valueOrNull;
  }
}

final activityManageControllerProvider =
    AutoDisposeAsyncNotifierProvider<ActivityManageScreenController, void>(
  () => ActivityManageScreenController(),
);

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final filterSelectedProvider = StateProvider.autoDispose<bool>((ref) => false);
final isBanned = StateProvider.autoDispose<bool>((ref) => false);

final skillsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(skillRepositoryProvider).getSkills(),
);

final selectedSkillsProvider = StateProvider<Set<Skill>>((ref) => {});

final organizationsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(organizationRepositoryProvider).getAll(),
);

final selectedOrganizationsProvider =
    StateProvider<Set<Organization>>((ref) => {});

class ScrollPagingControlNotifier extends PagedNotifier<int, Activity> {
  final ActivityRepository activityRepository;
  final ActivityStatus tabStatus;
  final String? searchPattern;
  final Set<Skill> skillList;
  final Set<Organization> orgList;
  final bool banned;
  final bool filterSelected;

  ScrollPagingControlNotifier({
    required this.activityRepository,
    required this.tabStatus,
    this.searchPattern,
    required this.banned,
    required this.skillList,
    required this.orgList,
    required this.filterSelected,
  }) : super(
          load: (page, limit) {
            return activityRepository.getActivities(
              query: ActivityQuery(
                limit: limit,
                offset: page * limit,
                name: searchPattern,
                status: [tabStatus],
                isDisabled: filterSelected ? banned : null,
                org: orgList.isEmpty ? null : orgList.map((e) => e.id).toList(),
                skill: skillList.isEmpty
                    ? null
                    : skillList.map((e) => e.id).toList(),
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final scrollPagingControlNotifier = StateNotifierProvider.autoDispose.family<
        ScrollPagingControlNotifier, PagedState<int, Activity>, ActivityStatus>(
    (ref, index) => ScrollPagingControlNotifier(
        activityRepository: ref.watch(activityRepositoryProvider),
        tabStatus: index,
        searchPattern: ref.watch(searchPatternProvider),
        banned: ref.watch(isBanned),
        filterSelected: ref.watch(filterSelectedProvider),
        skillList: ref.watch(selectedSkillsProvider),
        orgList: ref.watch(selectedOrganizationsProvider)));
