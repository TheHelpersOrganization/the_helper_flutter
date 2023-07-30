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

import '../../../../router/router.dart';
import '../../../profile/data/profile_repository.dart';
import '../../../shift/domain/shift.dart';
import '../controllers/mod_home_controller.dart';
import '../widgets/empty_list_widget.dart';
import '../widgets/home_welcome_section.dart';

class ModView extends ConsumerWidget {
  const ModView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final email = ref.watch(authServiceProvider).value!.account.email;
    final profile = ref.watch(profileProvider);
    final ongoingActivites = ref.watch(ongoingActivitiesProvider);
    final upcomingActivitiesState = ref.watch(upcomingActivitiesProvider);
    final managerShifts = ref.watch(managerShiftProvider).valueOrNull;
    final ongoingShift = managerShifts?.firstWhereOrNull(
      (shift) => shift.status == ShiftStatus.ongoing,
    );
    final upcomingShift = managerShifts
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
            : upcomingShift?.startTime.formatDayMonthYearBulletHourMinute() ??
                '';

    return profile.when(
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
              const SizedBox(
                height: 48,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ongoing Activities',
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
                child: ongoingActivites.when(
                  loading: () => ActivityListPlaceholder(
                    itemCount: 2,
                    itemWidth: context.mediaQuery.size.width * 0.7,
                    itemHeight: 380,
                  ),
                  error: (_, __) => const ErrorScreen(),
                  data: (data) => data.isEmpty
                      ? EmptyListWidget(
                          description: const [
                            'Your organization don\'t have any',
                            'ongoing activities'
                          ],
                          buttonTxt: 'Create one now',
                          onPress: () => context.pushNamed(
                              AppRoute.organizationActivityCreation.name),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              LargeActivityCard(activity: data[index]),
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
                    'Upcoming activities',
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
                  error: (er, __) {
                    print(er);
                    return const ErrorScreen();
                  },
                  data: (data) => data.isEmpty
                      ? EmptyListWidget(
                          description: const [
                            'Your organization don\'t have any',
                            'upcomming activities'
                          ],
                          buttonTxt: 'Create one now',
                          onPress: () => context.goNamed(
                              AppRoute.organizationActivityCreation.name),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              LargeActivityCard(activity: data[index]),
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
