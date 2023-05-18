import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/custom_list_tile.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/overflow_text.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_contact_card.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/location.dart';

final List<String> tabs = [
  'Shift',
];

class ActivityDetailScreen extends ConsumerWidget {
  const ActivityDetailScreen({super.key, required this.activityId});

  final int activityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(getActivityProvider(activityId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.goNamed(AppRoute.home.name);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      drawer: const AppDrawer(),
      body: activity.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) {
          return const ErrorScreen();
        },
        data: (activity) {
          if (activity == null) {
            return const ErrorScreen();
          }

          final startTime = activity.startTime ?? DateTime(2000);
          final startTimeFormat =
              DateFormat('EEE dd/MM, yyyy').format(startTime);
          final shortStartTimeFormat =
              DateFormat('dd/MM/yyyy').format(startTime);
          final endTime = activity.endTime ?? DateTime(2000);
          final endTimeFormat = DateFormat('EEE dd/MM, yyyy').format(startTime);
          final shortEndTimeFormat = DateFormat('dd/MM/yyyy').format(endTime);
          String slots = '';
          if (activity.maxParticipants != null) {
            slots +=
                '${activity.joinedParticipants}/${activity.maxParticipants}';
          } else {
            slots += '${activity.joinedParticipants} Joined';
          }
          final joinedPercentage = activity.maxParticipants == null
              ? null
              : activity.joinedParticipants! / activity.maxParticipants!;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: activity.thumbnail == null
                        ? SvgPicture.asset('assets/images/role_volunteer.svg')
                        : CachedNetworkImage(
                            imageUrl: getImageUrl(activity.thumbnail!),
                            width: context.mediaQuery.size.width,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    activity.name!,
                    style: context.theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Text('Organized by'),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          activity.organization!.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ExpandableText(
                    activity.organization!.description,
                    expandText: 'Show more',
                    collapseText: 'Show less',
                    maxLines: 3,
                    collapseOnTextTap: true,
                    linkColor: context.theme.primaryColor,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Participants',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(slots),
                    ],
                  ),
                  if (activity.maxParticipants != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(
                        value: joinedPercentage,
                      ),
                    ),
                  if (activity.maxParticipants != null)
                    Text(
                      '${activity.maxParticipants! - activity.joinedParticipants!} slots remaining',
                    )
                  else
                    const Text('Unlimited slots'),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.calendar_month_outlined),
                    ),
                    title: const Text('Date'),
                    subtitle: OverflowText(
                      text: Text(
                        '$startTime - $endTime',
                        style: TextStyle(
                            color: context.theme.colorScheme.secondary),
                      ),
                      fallback: Text(
                        '$shortStartTimeFormat - $shortEndTimeFormat',
                        style: TextStyle(
                            color: context.theme.colorScheme.secondary),
                      ),
                    ),
                  ),
                  CustomListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.location_on_outlined),
                    ),
                    title: const Text('Location'),
                    subtitle: Text(
                      getAddress(activity.location),
                      style:
                          TextStyle(color: context.theme.colorScheme.secondary),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Text(
                    'Skills Required',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Actual skill requirement depends on shift. Please check the shift details.',
                    style:
                        TextStyle(color: context.theme.colorScheme.secondary),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: activity.skills
                              ?.map(
                                (skill) => Chip(
                                  avatar: const Icon(Icons.wb_sunny_outlined),
                                  label: Text(skill.name),
                                ),
                              )
                              .toList() ??
                          <Widget>[],
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const Text(
                    'Contacts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (activity.contacts != null)
                    Column(
                      children: activity.contacts!
                          .map((c) => ActivityContactCard(contact: c))
                          .toList(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
