import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/overflow_text.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_contact_card.dart';
import 'package:the_helper/src/router/router.dart';
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
        error: (_, __) => const ErrorScreen(),
        data: (activity) {
          final startTime = activity.startTime ?? DateTime(2000);
          final startTimeFormat =
              DateFormat('EEE dd/MM, yyyy').format(startTime);
          final shortStartTimeFormat =
              DateFormat('dd/MM/yyyy').format(startTime);
          final endTime = activity.endTime ?? DateTime(2000);
          final endTimeFormat = DateFormat('EEE dd/MM, yyyy').format(startTime);
          final shortEndTimeFormat = DateFormat('dd/MM/yyyy').format(endTime);

          return Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/activity.png',
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
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Participants',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('10/20'),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(
                      value: 0.8,
                    ),
                  ),
                  const Text('5 slots remaining'),
                  const SizedBox(
                    height: 8,
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: OverflowText(
                      text: Text('$startTime - $endTime'),
                      fallback:
                          Text('$shortStartTimeFormat - $shortEndTimeFormat'),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text('Location'),
                    subtitle: Text(getAddress(activity.location)),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Skills Required',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        Chip(
                          avatar: Icon(Icons.wb_sunny_outlined),
                          label: Text('Environment'),
                        ),
                        Chip(
                          avatar: Icon(Icons.medical_services),
                          label: Text('Healthcare'),
                        ),
                        Chip(
                          avatar: Icon(Icons.construction),
                          label: Text('Constructing'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Contacts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const ActivityContactCard(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Manager'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('1232321321321'),
                        Text('ABC asdfd asdfsdfdsfsdf')
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
