import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/constant/fetch_list_size.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/volunteer_list_tile.dart';

class ShiftVolunteerParticipantTab extends ConsumerWidget {
  final int shiftId;
  const ShiftVolunteerParticipantTab({
    required this.shiftId,
    super.key,
  });
  static const String tabName = 'Participant';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: CustomScrollView(
        key: const PageStorageKey<String>(tabName),
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
                      shiftId: shiftId,
                      offset: offset,
                      limit: limit,
                      status: tabName,
                    ),
                  );
                  return tabData.when(
                    skipLoadingOnRefresh: false,
                    data: (volunteers) {
                      if (itemIndex >= volunteers.length) return null;
                      return VolunteerListTile(
                        volunteer: volunteers[itemIndex],
                        tab: tabName,
                      );
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
