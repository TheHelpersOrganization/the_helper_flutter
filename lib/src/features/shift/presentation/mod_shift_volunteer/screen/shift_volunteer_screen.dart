import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/delegate/tabbar_delegate.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer_arg.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/controller/shift_volunteer_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/widget/shift_volunteer_tab.dart';
import 'package:the_helper/src/utils/shift.dart';
import 'package:the_helper/src/router/router.dart';

class TabElement {
  // final List<ShiftVolunteerStatus> status;
  final TabElementTitle tabTitle;
  final ShiftVolunteerArg arg;
  const TabElement({
    // required this.status,
    required this.tabTitle,
    required this.arg,
  });
}

enum TabElementTitle {
  applicant(title: 'Applicants'),
  participant(title: 'Participants'),
  other(title: 'Others');

  final String title;
  const TabElementTitle({
    required this.title,
  });
}

List<TabElement> getTabs({required Shift shift}) {
  final status = shift.status;
  final participantTab = TabElement(
    arg: ShiftVolunteerArg(
        shiftId: shift.id, status: [ShiftVolunteerStatus.approved]),
    tabTitle: TabElementTitle.participant,
  );
  final applicantTab = TabElement(
    arg: ShiftVolunteerArg(
        shiftId: shift.id, status: [ShiftVolunteerStatus.pending]),
    tabTitle: TabElementTitle.applicant,
  );

  final otherTab = TabElement(
    arg: ShiftVolunteerArg(shiftId: shift.id, status: [
      ShiftVolunteerStatus.rejected,
      ShiftVolunteerStatus.removed,
      ShiftVolunteerStatus.left,
    ]),
    tabTitle: TabElementTitle.other,
  );
  switch (status) {
    case ShiftStatus.pending:
      return [
        applicantTab,
        participantTab,
        otherTab,
      ];
    default:
      return [
        participantTab,
        otherTab,
      ];
  }
}

class ShiftVolunteerScreen extends ConsumerWidget {
  final int shiftId;
  final int activityId;
  const ShiftVolunteerScreen({
    required this.shiftId,
    required this.activityId,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      changeVolunteerStatusControllerProvider,
      (_, state) => state.whenOrNull(
        error: (error, st) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        },
      ),
    );
    ref.listen<AsyncValue<void>>(
      changeVolunteersStatusControllerProvider,
      (_, state) => state.whenOrNull(
        error: (error, st) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        },
      ),
    );
    final shift = ref.watch(getShiftProvider(shiftId: shiftId));
    final isSearching = ref.watch(isSearchingProvider);
    final selectedVolunteer = ref.watch(selectedVolunteerProvider);
    final hasSelectedVolunteers = selectedVolunteer.isNotEmpty;
    return LoadingOverlay.customDarken(
      indicator: const LoadingDialog(
        titleText: "Loading",
      ),
      isLoading: ref.watch(changeVolunteerStatusControllerProvider).isLoading ||
          ref.watch(changeVolunteersStatusControllerProvider).isLoading,
      child: shift.when(
        // error: (error, stacktrace) => const Scaffold(
        //   body: CustomErrorWidget(),
        // ),
        error: (error, stackTrace) {
          return const Scaffold(body: CustomErrorWidget());
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),

        data: (shift) {
          final tabs = getTabs(shift: shift);
          final shiftStatus = shift.status;
          return DefaultTabController(
            length: tabs.length,
            child: Builder(
              builder: (context) {
                TabController tabController = DefaultTabController.of(context);
                final tab = tabs[tabController.index];
                tabController.addListener(() {
                  if (tabController.indexIsChanging) {
                    // ref.read(selectedVolunteerProvider.notifier).state = {};
                    ref.invalidate(selectedVolunteerProvider);
                  }
                });
                return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text.rich(
                      TextSpan(
                        text: 'Shift $shiftId',
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: getShiftStatusLabel(shift.status!),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      if (shiftStatus == ShiftStatus.ongoing ||
                          shiftStatus == ShiftStatus.pending)
                        IconButton(
                          icon: const Icon(Icons.qr_code),
                          onPressed: () => context.goNamed(
                            AppRoute.shiftQR.name,
                            pathParameters: {
                              'activityId': activityId.toString(),
                              'shiftId': shiftId.toString(),
                            },
                          ),
                        ),
                      if (!isSearching)
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            ref.read(isSearchingProvider.notifier).state =
                                !isSearching;
                          },
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.close_outlined),
                          onPressed: () {
                            ref.read(isSearchingProvider.notifier).state =
                                !isSearching;
                          },
                        )
                    ],
                  ),
                  body: NestedScrollView(
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverPersistentHeader(
                            pinned: true,
                            delegate: TabBarDelegate(
                              tabBar: TabBar(
                                tabs: tabs
                                    .map(
                                      (tab) => Tab(text: tab.tabTitle.title),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: tabs
                          .map(
                            (tab) => ShiftVolunteerTab(
                              shift: shift,
                              shiftStatus: shiftStatus!,
                              tabElement: tab,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  floatingActionButton: hasSelectedVolunteers
                      ? Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          spacing: 16.0,
                          children: [
                            if (tab.tabTitle == TabElementTitle.applicant) ...[
                              FloatingActionButton.extended(
                                icon: const Icon(Icons.check_outlined),
                                onPressed: () {
                                  ref
                                      .read(
                                          changeVolunteersStatusControllerProvider
                                              .notifier)
                                      .approveVolunteers(
                                        shiftId: shiftId,
                                        volunteerIds: selectedVolunteer
                                            .map((volunteer) => volunteer.id)
                                            .toList(),
                                      );
                                  ref.invalidate(selectedVolunteerProvider);
                                },
                                label: const Text('Approve'),
                              ),
                              FloatingActionButton.extended(
                                icon: const Icon(Icons.cancel_outlined),
                                onPressed: () {
                                  ref
                                      .read(
                                          changeVolunteersStatusControllerProvider
                                              .notifier)
                                      .rejectVolunteers(
                                        shiftId: shiftId,
                                        volunteerIds: selectedVolunteer
                                            .map((volunteer) => volunteer.id)
                                            .toList(),
                                      );
                                  ref.invalidate(selectedVolunteerProvider);
                                },
                                label: const Text('Decline'),
                              ),
                            ],
                            if (tab.tabTitle ==
                                TabElementTitle.participant) ...[
                              if (shiftStatus == ShiftStatus.pending)
                                FloatingActionButton.extended(
                                  icon: const Icon(Icons.cancel_outlined),
                                  onPressed: () {
                                    ref
                                        .read(
                                            changeVolunteersStatusControllerProvider
                                                .notifier)
                                        .removeVolunteers(
                                          shiftId: shiftId,
                                          volunteerIds: selectedVolunteer
                                              .map((volunteer) => volunteer.id)
                                              .toList(),
                                        );
                                    ref.invalidate(selectedVolunteerProvider);
                                  },
                                  label: const Text('Remove'),
                                ),
                              if (shiftStatus != ShiftStatus.pending) ...[
                                if (selectedVolunteer
                                        .map((volunteer) =>
                                            volunteer.isCheckInVerified ??
                                            false)
                                        .toSet()
                                        .toList()
                                        .length ==
                                    1)
                                  FloatingActionButton.extended(
                                    icon: selectedVolunteer
                                                .first.isCheckInVerified ??
                                            false
                                        ? const Icon(Icons.verified_outlined)
                                        : const Icon(Icons.verified),
                                    onPressed: () {
                                      ref
                                          .read(
                                              changeVolunteersStatusControllerProvider
                                                  .notifier)
                                          .toggleVerifyAttendance(
                                            shiftId: shiftId,
                                            volunteers: selectedVolunteer
                                                .map((volunteer) => volunteer)
                                                .toList(),
                                            checkIn: true,
                                          );
                                      ref.invalidate(selectedVolunteerProvider);
                                    },
                                    label: selectedVolunteer
                                                .first.isCheckInVerified ??
                                            false
                                        ? const Text('Unverify check-in')
                                        : const Text('Verify check-in'),
                                  ),
                                if (selectedVolunteer
                                        .map((volunteer) =>
                                            volunteer.isCheckOutVerified ??
                                            false)
                                        .toSet()
                                        .toList()
                                        .length ==
                                    1)
                                  FloatingActionButton.extended(
                                    icon: selectedVolunteer
                                                .first.isCheckOutVerified ??
                                            false
                                        ? const Icon(Icons.verified_outlined)
                                        : const Icon(Icons.verified),
                                    onPressed: () {
                                      ref
                                          .read(
                                              changeVolunteersStatusControllerProvider
                                                  .notifier)
                                          .toggleVerifyAttendance(
                                            shiftId: shiftId,
                                            volunteers: selectedVolunteer
                                                .map((volunteer) => volunteer)
                                                .toList(),
                                            checkIn: false,
                                          );
                                      ref.invalidate(selectedVolunteerProvider);
                                    },
                                    label: selectedVolunteer
                                                .first.isCheckOutVerified ??
                                            false
                                        ? const Text('Unverify check-out')
                                        : const Text('Verify check-out'),
                                  ),
                              ],
                            ],

                            // FloatingActionButton.extended(
                            //   icon: const Icon(Icons.select_all_outlined),
                            // ),
                            // FloatingActionButton.extended(
                            //   icon: const Icon(Icons.thumb_up_alt_outlined),
                            // ),
                          ],
                          // children: [
                          //   FloatingActionButton.extended(
                          //     onPressed: () {},
                          //     label: const Text('Verify'),
                          //     icon: const Icon(Icons.add),
                          //   ),
                          //   FloatingActionButton(
                          //     onPressed: () {},
                          //     child: const Icon(Icons.add),
                          //   ),
                          // ].reversed.toList(),
                        )
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
