import 'dart:async';
import 'dart:collection';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/skill/data/skill_repository.dart';
import 'package:the_helper/src/features/skill/domain/skill_query.dart';

import '../../../../activity/application/mod_activity_service.dart';
import '../../../../activity/domain/activity.dart';
import '../../../../skill/domain/skill.dart';

part 'organization_overview_controller.g.dart';

class OrganizationOverviewData {
  final int count;
  final int ongoingCount;
  final List<Skill>? skillList;

  OrganizationOverviewData({
    required this.count,
    required this.ongoingCount,
    this.skillList,
  });
}

@riverpod
Future<OrganizationOverviewData> organizationOverviewController(
  OrganizationOverviewControllerRef ref, {
  required int id,
}) async {
  final keepAliveLink = ref.keepAlive();
  Timer(const Duration(minutes: 5), () {
    keepAliveLink.close();
  });
  final ModActivityService service = ref.watch(modActivityServiceProvider);
  final SkillRepository skillRepo = ref.watch(skillRepositoryProvider);
  final List<Activity> activities = await service.getActivitiesWithOrganization(
    organizationId: id,
  );

  List<int> skills = [];
  for (var e in activities) {
    if (e.skillIds != null) {
      skills = [...skills, ...(e.skillIds!)];
    }
  }
  var map = {};

  for (var e in skills) {
    if (!map.containsKey(e)) {
      map[e] = 1;
    } else {
      map[e] += 1;
    }
  }
  var sortedKeys = map.keys.toList(growable: false)
    ..sort((k2, k1) => map[k1].compareTo(map[k2]));
  LinkedHashMap<int, int> sortedMap = LinkedHashMap.fromIterable(
      sortedKeys.take(5),
      key: (k) => k,
      value: (k) => map[k]);

  final List<Skill> skillsData = await skillRepo.getSkills(
    query: SkillQuery(
      ids: sortedMap.keys.toList(),
    )
  );

  var ongoingActivities = activities.filter((t) => t.status == 'ongoing');
  return OrganizationOverviewData(
      count: activities.length,
      ongoingCount: ongoingActivities.length,
      skillList: skillsData
  );
}
