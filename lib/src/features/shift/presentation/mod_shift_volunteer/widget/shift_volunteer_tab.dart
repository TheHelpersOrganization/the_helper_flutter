import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
// import 'package:the_helper/src/common/riverpod_infinite_scroll/src/river_paged_builder.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/controller/shift_volunteer_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/screen/shift_volunteer_screen.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/widget/volunteer_list_tile.dart';

// final selectedItemsProvider = StateProvider<List<bool>>((ref) => []);

class ShiftVolunteerTab extends ConsumerWidget {
  final Shift shift;
  final ShiftStatus shiftStatus;
  // final String tabTitle;
  final TabElement tabElement;
  const ShiftVolunteerTab({
    required this.shift,
    required this.shiftStatus,
    required this.tabElement,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final tabData = ref.watch(
    // shiftVolunteerControllerProvider(shiftId: shiftId, status: tabName));
    final selectedVolunteer = ref.watch(selectedVolunteerProvider);
    final volunteers = ref
        .watch(
          shiftVolunteerListPagedNotifierProvider(
            tabElement.arg,
          ),
        )
        .records;
    final volunteerCount = volunteers?.length;
    final isSearching = ref.watch(isSearchingProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    return SafeArea(
      child: CustomScrollView(
        key: PageStorageKey<String>(tabElement.tabTitle.title),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          if (isSearching)
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverToBoxAdapter(
                child: DebounceSearchBar(
                  initialValue: ref.watch(searchPatternProvider),
                  hintText: 'Search volunteers',
                  debounceDuration: const Duration(seconds: 1),
                  // small: true,
                  onDebounce: (value) {
                    ref.read(searchPatternProvider.notifier).state =
                        value.trim().isNotEmpty ? value.trim() : null;
                    ref.read(selectedVolunteerProvider.notifier).state = {};
                    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
                  },
                  onClear: () {
                    ref.read(searchPatternProvider.notifier).state = null;
                    ref.read(selectedVolunteerProvider.notifier).state = {};

                    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
                  },
                ),
              ),
            ),
          if (searchPattern != null)
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: 'Search result for ',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                          children: [
                            TextSpan(
                                text: searchPattern,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ]),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(searchPatternProvider.notifier).state = null;
                        ref.read(isSearchingProvider.notifier).state =
                            !isSearching;
                        ref.invalidate(shiftVolunteerListPagedNotifierProvider);
                      },
                      child: const Text('Clear search'),
                    ),
                  ],
                ),
              ),
            ),
          if (volunteerCount != null && volunteerCount > 0)
            SliverToBoxAdapter(
              child: CheckboxListTile(
                tristate: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                    'Select (${selectedVolunteer.length}/$volunteerCount)'),
                // value: (volunteerCount > 0 &&
                //         selectedVolunteer.length == volunteerCount),
                value: selectedVolunteer.isEmpty
                    ? false
                    : (selectedVolunteer.length == volunteerCount)
                        ? true
                        : null,

                onChanged: (bool? value) {
                  if (value == true) {
                    ref.read(selectedVolunteerProvider.notifier).state = {
                      ...volunteers!.map((volunteer) => volunteer).toList(),
                    };
                  } else {
                    ref.read(selectedVolunteerProvider.notifier).state = {};
                  }
                },
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: RiverPagedBuilder.autoDispose(
              limit: 20,
              provider: shiftVolunteerListPagedNotifierProvider(
                tabElement.arg,
              ),
              firstPageKey: 0,
              itemBuilder:
                  (BuildContext context, ShiftVolunteer item, int index) =>
                      VolunteerListTile(
                          shift: shift,
                          volunteer: item,
                          shiftStatus: shiftStatus),
              pagedBuilder: (PagingController<int?, ShiftVolunteer> controller,
                      PagedChildBuilderDelegate<ShiftVolunteer> builder) =>
                  PagedSliverList(
                pagingController: controller,
                builderDelegate: builder,
              ),
              firstPageErrorIndicatorBuilder: (context, controller) {
                return CustomErrorWidget(
                  onRetry: () => controller.retryLastFailedRequest(),
                );
              },
              newPageErrorIndicatorBuilder: (context, controller) =>
                  CustomErrorWidget(
                onRetry: () => controller.retryLastFailedRequest(),
              ),
              noItemsFoundIndicatorBuilder: (context, _) =>
                  const NoDataFound.simple(
                contentTitle: 'No volunteer found',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
