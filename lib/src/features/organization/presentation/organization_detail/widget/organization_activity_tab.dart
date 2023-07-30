import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/features/organization/presentation/organization_detail/controller/organization_activity_controller.dart';

import '../../../../../router/router.dart';

class OrganizationActivityTab extends ConsumerWidget {
  final int id;
  const OrganizationActivityTab({
    super.key,
    required this.id,
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
                    organizationActivityControllerProvider(
                      id: id,
                      page: page,
                      size: size,
                    ),
                  );
                  return pageValue.when(
                    data: (data) {
                      if (itemIndex >= data.length) return null;
                      return ListTile(
                        // isThreeLine: true,
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
                          data[itemIndex].name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${DateFormat("dd/MM/yyyy").format(data[itemIndex].startTime!)} - ${DateFormat("dd/MM/yyyy").format(data[itemIndex].endTime!)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
            ),
          ),
        ],
      ),
    );
  }
}
