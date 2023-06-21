import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/summary_card.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/router/router.dart';

import '../../../../common/screens/error_screen.dart';
import '../../../authentication/application/auth_service.dart';
import '../../../profile/data/profile_repository.dart';
import '../controllers/admin_home_controller.dart';
import '../widgets/adminDataHolder.dart';

class AdminView extends ConsumerWidget {
  const AdminView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authServiceProvider).value!.account.email;
    final userName = ref.watch(profileProvider);
    final adminData = ref.watch(adminHomeControllerProvider);

    return userName.when(
        error: (_, __) => const ErrorScreen(),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'Welcome '),
                          TextSpan(
                              text: data.lastName ?? data.username ?? email)
                        ],
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 180,
                  color: Colors.blue,
                  child: Center(
                    child: Column(
                      children: [
                        const Text('1000 Online'),
                        IconButton(onPressed: () => 
                        context.pushNamed(AppRoute.screenBuilderCanvas.name), 
                        icon: const Icon(Icons.golf_course)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: adminData.when(
                    loading: () => AdminDataHolder(
                      itemCount: 3,
                      itemWidth: context.mediaQuery.size.width * 0.9,
                      itemHeight: 80,
                    ),
                    error: (er, st) => const ErrorScreen(),
                    data: (data) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SummaryCard(
                          icon: Icons.account_circle_outlined,
                          data: data.account.toString(),
                          info: 'Accounts',
                          path: 'account-manage',
                        ),
                        SummaryCard(
                          icon: Icons.work,
                          data: data.organization.toString(),
                          info: 'Organizations',
                          path: 'organization-admin-manage',
                        ),
                        SummaryCard(
                          icon: Icons.volunteer_activism,
                          data: data.activity.toString(),
                          info: 'Ongoing activities',
                          path: 'activity-manage',
                        ),
                      ],
                    ),
                  ),
                  )
                ),
              ],
            ));
  }
}
// class AdminView extends ConsumerWidget {
//   const AdminView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           Container(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Center(
//               child: Text(
//                 'Welcome Admin Name',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () => context.goNamed('organization-manage'),
//                 style: ButtonStyle(
//                   shape: MaterialStateProperty.all(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18.0),
//                       // side: const BorderSide(color: Colors.red)
//                     )
//                   ),
//                   padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
//                   fixedSize: MaterialStateProperty.all(const Size(120, 120)),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.work),
//                     Text('Organization'),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () => context.goNamed('account-manage'),
//                 style: ButtonStyle(
//                   shape: MaterialStateProperty.all(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18.0),
//                       // side: const BorderSide(color: Colors.red)
//                     )
//                   ),
//                   padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
//                   fixedSize: MaterialStateProperty.all(const Size(120, 120)),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.account_circle_outlined),
//                     Text('Accounts'),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () => context.goNamed('activity-manage'),
//                 style: ButtonStyle(
//                   shape: MaterialStateProperty.all(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18.0),
//                       // side: const BorderSide(color: Colors.red)
//                     )
//                   ),
//                   padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
//                   fixedSize: MaterialStateProperty.all(const Size(120, 120)),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.volunteer_activism),
//                     Text('Activities'),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 'Summary',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           Container(
//             height: 250.0,
//             width: 250.0,
//             color: Colors.blueGrey,
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           SizedBox(
//               height: 100.0,
//               child: ListView.builder(
//                 physics: const ClampingScrollPhysics(),
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 3,
//                 itemBuilder: (BuildContext context, int index) =>
//                     const SummaryCard(
//                   title: 'Something',
//                   total: 120,
//                   info: 'Something',
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }
