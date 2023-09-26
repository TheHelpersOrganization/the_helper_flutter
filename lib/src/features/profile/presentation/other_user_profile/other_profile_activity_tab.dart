import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'other_profile_activity_controller.dart';
import 'package:the_helper/src/router/router.dart';
// import 'package:the_helper/src/utils/utility_functions.dart';

class OtherProfileActivityTab extends ConsumerWidget {
  final int id;
  const OtherProfileActivityTab({
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: CustomScrollView(
        primary: false,
        key: const PageStorageKey<String>('Activity'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverFixedExtentList(
              itemExtent: 56.0,
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  const size = 20;
                  final page = index ~/ size;
                  final itemIndex = index % size;
                  final pageValue = ref.watch(
                    activityControllerProvider(
                      id: id,
                      page: page,
                      size: size,
                    ),
                  );
                  return pageValue.when(
                    data: (data) {
                      if (itemIndex >= data.length) return null;
                      return ListTile(
                        // isThreeLine: false,
                        onTap: () {
                          context.pushNamed(
                            AppRoute.activity.name,
                            pathParameters: {
                              'activityId': data[itemIndex].id.toString(),
                            },
                          );
                        },
                        leading: const Icon(Icons.star_outline),
                        title: Text(
                          maxLines: 1,
                          data[itemIndex].name!,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          maxLines: 1,
                          '${DateFormat("dd/MM/yyyy").format(data[itemIndex].startTime!)} - ${DateFormat("dd/MM/yyyy").format(data[itemIndex].endTime!)}',
                          overflow: TextOverflow.ellipsis,
                        ),

                        // trailing: Text(
                        //   getInitials(activity.organization!.name),
                        // ),
                      );
                    },
                    error: (Object error, StackTrace stackTrace) =>
                        const Text('Some error orrcur!'),
                    loading: () {
                      if (itemIndex != 0) return null;
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                },
              ),
              // delegate: SliverChildListDelegate([
              //   for (final activity in activities)
              //     ListTile(
              //       isThreeLine: true,
              //       onTap: () {
              //         context.pushNamed(
              //           AppRoute.activity.name,
              //           pathParameters: {
              //             'activityId': activity.id.toString(),
              //           },
              //         );
              //       },
              //       leading: const Icon(Icons.star_outline),
              //       title: Text(activity.name!),
              //       subtitle: Text(
              //           '${DateFormat("dd/MM/yyyy").format(activity.startTime!)} - ${DateFormat("dd/MM/yyyy").format(activity.endTime!)}'),

              //       // trailing: Text(
              //       //   getInitials(activity.organization!.name),
              //       // ),
              //     ),
              // ]),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityListTile extends StatelessWidget {
  final Activity activity;
  const ActivityListTile({
    required this.activity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
