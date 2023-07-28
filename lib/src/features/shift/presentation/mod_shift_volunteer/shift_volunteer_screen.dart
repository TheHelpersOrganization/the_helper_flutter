import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/delegate/tabbar_delegate.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_applicant_tab.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_other_tab.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_participant_tab.dart';

const List<Tab> tabs = [
  Tab(
    text: 'Applicants',
  ),
  Tab(
    text: 'Participants',
  ),
  Tab(
    text: 'Others',
  ),
];

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
    // final shiftVolunteers = ref.watch(shiftVolunteerControllerProvider);
    // return shiftVolunteers.when(
    // loading: () => const Center(
    // child: CircularProgressIndicator(),
    // ),
    // error: (error, _) => Text('Error: $error'),
    // data: (shiftVolunteer) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Shift $shiftId Manage'),
        actions: const [],
      ),
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: TabBarDelegate(
                    tabBar: const TabBar(
                      tabs: tabs,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(children: [
            ShiftVolunteerApplicantTab(shiftId: shiftId, activityId: activityId),
            // ShiftVolunteerTab(
            // shiftId: shiftId,
            // tabName: 'Applicants',
            // ),
            ShiftVolunteerParticipantTab(shiftId: shiftId, activityId: activityId),
            ShiftVolunteerOtherTab(shiftId: shiftId, activityId: activityId),
            // ParticipantTab(),
          ]),
        ),
      ),
    );
    // },
    // );
  }
}

// class ShiftVolunteerTab extends ConsumerWidget {
//   final int shiftId;
//   final String tabName;
//   const ShiftVolunteerTab({
//     required this.shiftId,
//     required this.tabName,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SafeArea(
//       child: CustomScrollView(
//         key: PageStorageKey<String>(tabName),
//         slivers: [
//           SliverOverlapInjector(
//             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.all(8.0),
//             sliver: SliverFixedExtentList(
//               itemExtent: 56.0,
//               delegate: SliverChildBuilderDelegate(
//                 (BuildContext context, int index) {
//                   final limit = ref.watch(fetchListSizeProvider);
//                   final offset = (index ~/ limit) * limit;
//                   final itemIndex = index % limit;
//                   final String? status;
//                   switch (tabName) {
//                     case 'Applicants':
//                       status = 'approved';
//                       break;
//                     case 'Pending':
//                       status = 'pending';
//                       break;
//                     default:
//                       status = null;
//                       break;
//                   }
//                   // print(status);
//                   final pageData = ref.watch(
//                     shiftVolunteerControllerProvider(
//                       offset: offset,
//                       limit: limit,
//                       shiftId: shiftId,
//                       status: status,
//                     ),
//                   );
//                   return pageData.when(
//                     data: (data) {
//                       if (itemIndex >= data.length) return null;
//                       return ListTile(
//                         isThreeLine: true,
//                         onTap: () {
//                           context.pushNamed(
//                             AppRoute.profile.name,
//                             // pathParameters: data[itemIndex].accountId
//                           );
//                         },
//                         onLongPress: () {},
//                         title: Text(data[itemIndex].accountId.toString()),
//                         subtitle: Text(data[itemIndex].completion.toString()),
//                       );
//                     },
//                     error: (Object error, StackTrace stackTrace) =>
//                         Text('Some error orrcur!: $error'),
//                     loading: () {
//                       if (itemIndex != 0) return null;
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     },
//                   );
//                 },
//                 childCount: 10,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
