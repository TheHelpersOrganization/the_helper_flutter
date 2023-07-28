import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/constant/fetch_list_size.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/volunteer_list_tile.dart';

class ShiftVolunteerParticipantTab extends ConsumerWidget {
  final int shiftId;
  final int activityId;
  const ShiftVolunteerParticipantTab({
    required this.shiftId,
    required this.activityId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: CustomScrollView(
        key: const PageStorageKey<String>('Participant'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final limit = ref.watch(fetchListSizeProvider);
                  final offset = (index ~/ limit) * limit;
                  final itemIndex = index % limit;
                  final tabData = ref.watch(
                    shiftVolunteerControllerProvider(
                      activityId: activityId,
                      shiftId: shiftId,
                      offset: offset,
                      limit: limit,
                      status: 'Participant',
                    ),
                  );
                  return tabData.when(
                    data: (data) {
                      if (itemIndex >= data.length) return null;
                      final profile = data[itemIndex].profile!;
                      return VolunteerListTile(profile: profile);
                    },
                    error: (Object error, StackTrace stackTrace) =>
                        const Text('Error'),
                    loading: () {
                      if (itemIndex != 0) return null;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
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
