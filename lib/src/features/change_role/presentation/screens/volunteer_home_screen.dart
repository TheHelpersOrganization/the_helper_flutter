import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/alert.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_list_placeholder.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/large_activity_card.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/volunteer_home_controller.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/home_welcome_section.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/volunteer_analytics.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

class VolunteerView extends ConsumerWidget {
  const VolunteerView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authServiceProvider).value!.account.email;
    final volunteerName = ref.watch(profileProvider);
    final suggestedActivitiesState = ref.watch(suggestedActivitiesProvider);
    final upcomingActivitiesState = ref.watch(upcomingActivitiesProvider);
    final volunteerShifts = ref.watch(volunteerShiftProvider).valueOrNull;
    final ongoingShift = volunteerShifts?.firstWhereOrNull(
      (shift) => shift.status == ShiftStatus.ongoing,
    );
    final upcomingShift = volunteerShifts
        ?.where(
          (shift) =>
              shift.status == ShiftStatus.pending &&
              shift.startTime.isBefore(
                DateTime.now().add(const Duration(hours: 24)),
              ),
        )
        .sortWithDate((instance) => instance.startTime)
        .firstOrNull;
    final timeDisplay = upcomingShift?.startTime.isToday == true
        ? '${upcomingShift?.startTime.formatHourSecond()} Today'
        : upcomingShift?.startTime.isTomorrow == true
            ? '${upcomingShift?.startTime.formatHourSecond()} Tomorrow'
            : upcomingShift?.startTime.formatDayMonthYearBulletHourSecond() ??
                '';

    return volunteerName.when(
      error: (_, __) => const ErrorScreen(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (data) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeWelcomeSection(
                volunteerName: data.lastName ?? data.username ?? 'Back',
              ),
              if (ongoingShift != null)
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 24),
                  child: Alert(
                    leading: const Icon(
                      Icons.info_outline,
                    ),
                    message: Text.rich(
                      TextSpan(
                        text: 'You have an ongoing shift ',
                        children: [
                          TextSpan(
                            text: ongoingShift.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' now'),
                        ],
                      ),
                      maxLines: 2,
                    ),
                    action: IconButton(
                      onPressed: () {
                        context.goNamed(AppRoute.shift.name, pathParameters: {
                          'activityId': ongoingShift.activityId.toString(),
                          'shiftId': ongoingShift.id.toString(),
                        });
                      },
                      icon: const Icon(Icons.navigate_next_outlined),
                    ),
                  ),
                )
              else if (upcomingShift != null)
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 24),
                  child: Alert(
                    leading: const Icon(
                      Icons.info_outline,
                    ),
                    message: Wrap(
                      spacing: 2,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Shift ',
                            children: [
                              TextSpan(
                                text: upcomingShift.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'is starting soon at ',
                            children: [
                              const WidgetSpan(
                                child: Icon(
                                  Icons.access_time_outlined,
                                  size: 16,
                                ),
                              ),
                              TextSpan(
                                text: ' $timeDisplay',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    action: IconButton(
                      onPressed: () {
                        context.goNamed(AppRoute.shift.name, pathParameters: {
                          'activityId': upcomingShift.activityId.toString(),
                          'shiftId': upcomingShift.id.toString(),
                        });
                      },
                      icon: const Icon(Icons.navigate_next_outlined),
                    ),
                  ),
                )
              else
                const SizedBox(
                  height: 24,
                ),
              const VolunteerAnalytics(),
              const SizedBox(
                height: 48,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Activities',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See more',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 380.0,
                child: upcomingActivitiesState.when(
                  loading: () => ActivityListPlaceholder(
                    itemCount: 2,
                    itemWidth: context.mediaQuery.size.width * 0.7,
                    itemHeight: 380,
                  ),
                  error: (_, __) => const ErrorScreen(),
                  data: (upcomingActivities) => ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: upcomingActivities.length,
                    itemBuilder: (BuildContext context, int index) =>
                        LargeActivityCard(activity: upcomingActivities[index]),
                  ),
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Activities you may interest',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See more',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 380.0,
                child: suggestedActivitiesState.when(
                  loading: () => ActivityListPlaceholder(
                    itemCount: 2,
                    itemWidth: context.mediaQuery.size.width * 0.7,
                    itemHeight: 380,
                  ),
                  error: (_, __) => const ErrorScreen(),
                  data: (suggestedActivities) => ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: suggestedActivities.length,
                    itemBuilder: (BuildContext context, int index) =>
                        LargeActivityCard(activity: suggestedActivities[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
