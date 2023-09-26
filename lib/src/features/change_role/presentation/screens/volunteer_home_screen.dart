import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_list_placeholder.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/large_activity_card.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/volunteer_home_controller.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/home_welcome_section.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/volunteer_analytics.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/volunteer_home/email_verification_alert.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/volunteer_home/ongoing_shift_alert.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/volunteer_home/upcoming_shift_alert.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/screen/my_shift_screen.dart';
import 'package:the_helper/src/router/router.dart';

import '../widgets/volunteer_analytics_main_card.dart';
import '../widgets/volunteer_data_holder.dart';

class VolunteerView extends ConsumerWidget {
  const VolunteerView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmailVerified =
        ref.watch(authServiceProvider).value!.account.isEmailVerified;
    final profile = ref.watch(profileProvider);
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

    final volunteerData = ref.watch(volunteerStatusProvider);
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
              isEmailVerified
                  ? const SizedBox()
                  : const Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: EmailVerificationAlert(),
                    ),
              if (ongoingShift != null)
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 24),
                  child: OngoingShiftAlert(
                    ongoingShift: ongoingShift,
                  ),
                )
              else if (upcomingShift != null)
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 24),
                  child: UpcomingShiftAlert(upcomingShift: upcomingShift),
                )
              else
                const SizedBox(
                  height: 24,
                ),
              SizedBox(
                height: 240,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 3,
                      child: VolunteerAnalyticsMainCard(skillList: data.skills),
                    ),
                    Flexible(
                      flex: 2,
                      child: volunteerData.when(
                        data: (data) => VolunteerAnalytics(
                          totalActivity: data.totalActivity,
                          increasedActivity: data.increasedActivity,
                          totalHour: data.totalHour,
                          increasedHour: data.increasedHour,
                        ),
                        loading: () => VolunteerDataHolder(
                          itemCount: 2,
                          itemWidth: context.mediaQuery.size.width * 0.38,
                          itemHeight: 90,
                        ),
                        error: (_, __) => const CustomErrorWidget(),
                      ),
                    ),
                  ],
                ),
              ),
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
                  if (upcomingActivitiesState.valueOrNull?.isNotEmpty == true)
                    TextButton(
                      onPressed: () {
                        context.goNamed(
                          AppRoute.activityMy.name,
                          queryParameters: {
                            'tab': MyShiftScreenTabType.upcoming.name,
                          },
                        );
                      },
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
                  error: (_, __) {
                    // print(__);
                    // print(_);
                    return const CustomErrorWidget();
                  },
                  data: (upcomingActivities) => upcomingActivities.isEmpty
                      ? Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/images/empty-folder-optimized.svg',
                                height: 100,
                                width: 100,
                                allowDrawingOutsideViewBox: true,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'You don\'t have any',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    'upcoming activities',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  FilledButton(
                                    onPressed: () => context
                                        .goNamed(AppRoute.activitySearch.name),
                                    child: const Text('Join one now'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          //shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: upcomingActivities.length,
                          itemBuilder: (BuildContext context, int index) =>
                              LargeActivityCard(
                                  width: 300,
                                  activity: upcomingActivities[index]),
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
                    onPressed: () {
                      context.pushNamed(AppRoute.activitySuggestion.name);
                    },
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
                  error: (_, __) => const CustomErrorWidget(),
                  data: (suggestedActivities) => ListView.builder(
                    // shrinkWrap: true,
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
