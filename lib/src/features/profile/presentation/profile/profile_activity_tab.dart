import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/router/router.dart';
// import 'package:the_helper/src/utils/utility_functions.dart';

class ProfileActivityTab extends StatelessWidget {
  final AsyncValue<List<Activity>> activities;
  const ProfileActivityTab({
    required this.activities,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        primary: true,
        key: const PageStorageKey<String>('Activity'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          activities.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, st) => SliverFillRemaining(
              child: Center(
                child: Text('Error: $error'),
              ),
            ),
            data: (activities) => SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverFixedExtentList(
                itemExtent: 56.0,
                delegate: SliverChildListDelegate([
                  for (final activity in activities)
                    ListTile(
                      isThreeLine: true,
                      onTap: () {
                        context.pushNamed(
                          AppRoute.activity.name,
                          pathParameters: {
                            'activityId': activity.id.toString(),
                          },
                        );
                      },
                      leading: const Icon(Icons.star_outline),
                      title: Text(activity.name!),
                      subtitle: Text(
                          '${DateFormat("dd/MM/yyyy").format(activity.startTime!)} - ${DateFormat("dd/MM/yyyy").format(activity.endTime!)}'),

                      // trailing: Text(
                      //   getInitials(activity.organization!.name),
                      // ),
                    ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
