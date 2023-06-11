import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/widget/detail_list_tile.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

class ProfileDetailTab extends StatelessWidget {
  final Profile profile;

  const ProfileDetailTab({
    required this.profile,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        primary: true,
        key: const PageStorageKey<String>('Detail'),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverFixedExtentList(
              itemExtent: 48.0,
              delegate: SliverChildListDelegate([
                DetailListTile(
                    label: 'Phone Number',
                    value: profile.phoneNumber ?? 'Unknown'),
                DetailListTile(
                    label: 'First Name', value: profile.firstName ?? 'Unknown'),
                DetailListTile(
                    label: 'Last Name', value: profile.lastName ?? 'Unknown'),
                DetailListTile(
                    label: 'Date of Birth',
                    value:
                        DateFormat('dd-MM-yyyy').format(profile.dateOfBirth!)),
                DetailListTile(
                    label: 'Gender', value: profile.gender ?? 'Unknown'),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// class ProfileDetailTab extends ConsumerWidget {
//   const ProfileDetailTab({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final profile = ref.watch(profileProvider);
//     return profile.when(
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (error, stack) => Text('Error: $error'),
//       data: (profile) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 104),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Username: '),
//                 Text(profile.username ?? ''),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Phone Number: '),
//                 Text(profile.phoneNumber ?? ''),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('First Name: '),
//                 Text(profile.firstName ?? ''),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Last Name: '),
//                 Text(profile.lastName ?? ''),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Gender: '),
//                 Text(profile.gender ?? ''),
//               ],
//             ),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //   children: [
//             //     const Text('Address: '),
//             //     Text(
//             //         '${profile.addressLine1 ?? ''}, ${profile.addressLine2 ?? ''}'),
//             //   ],
//             // ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Date of birth: '),
//                 Text(profile.dateOfBirth == null
//                     ? ''
//                     : DateFormat('yyyy-MM-dd').format(profile.dateOfBirth!)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
