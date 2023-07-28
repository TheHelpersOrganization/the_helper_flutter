// class ActivityListItem extends ConsumerWidget {
//   final Activity data;

//   const ActivityListItem({
//     super.key,
//     required this.data,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     void showLoadingDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       useRootNavigator: false,
//       builder: (context) => const LoadingDialog(
//         titleText: 'Processing...',
//       ),
//     );
//   }

//   void showErrorDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       useRootNavigator: false,
//       builder: (dialogContext) => SimpleDialog(
//             alignment: Alignment.center,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 24,
//               vertical: 24,
//             ),
//             children: [
//               Center(
//                 child: Text(
//                   'Something went wrong',
//                   style: TextStyle(
//                     color: dialogContext.theme.primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               FilledButton(
//                 onPressed: () {
//                   dialogContext.pop();
//                 },
//                 child: const Text('Ok'),
//               ),
//             ],
//           ));
//     }
//     void showOptionSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return CustomModalBottomSheet(
//           titleText: 'Activity options',
//           content: Column(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.account_circle_outlined),
//                 title: const Text('View activity'),
//                 onTap: () {
//                   context.pop();
//                   context.pushNamed(
//                     AppRoute.activity.name,
//                     pathParameters: {
//                       'activityId': data.id.toString(),
//                     },
//                   );
//                 },
//               ),
//               data.isDisabled!
//                   ? ListTile(
//                       leading: const Icon(Icons.task_alt),
//                       title: const Text('Unbanned activity'),
//                       onTap: () async {
//                         context.pop();
//                         showLoadingDialog();
//                         final res = await ref
//                             .watch(activityManageControllerProvider.notifier)
//                             .ban(data.id!);

//                         if (context.mounted) {
//                           if (res == null) {
//                             showErrorDialog();
//                           }
//                           context.pop();
//                         }
//                         ref.invalidate(
//                             scrollPagingControlNotifier(data.status!));
//                       },
//                     )
//                   : ListTile(
//                       leading: const Icon(Icons.group_off),
//                       title: const Text('Banned activity'),
//                       onTap: () async {
//                         context.pop();
//                         showLoadingDialog();
//                         final res = await ref
//                             .watch(activityManageControllerProvider.notifier)
//                             .unban(data.id!);

//                         if (context.mounted) {
//                           if (res == null) {
//                             showErrorDialog();
//                           }
//                           context.pop();
//                         }
//                         ref.invalidate(
//                             scrollPagingControlNotifier(data.status!));
//                       },
//                     ),
//             ],
//           ),
//         );
//       });
//     }

//     final org = ref.watch(getOrganizationProvider(data.organizationId!));
//     final startDate = DateFormat("mm/dd/y").format(data.startTime!);
//     final endDate = DateFormat("mm/dd/y").format(data.endTime!);
//     return Container(
//       decoration: BoxDecoration(
//           border:
//               Border(top: BorderSide(color: Theme.of(context).dividerColor))),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5.0),
//         child: org.when(
//           loading: () => const Center(
//             child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 40),
//                 child: CircularProgressIndicator()),
//           ),
//           error: (_, __) => const CustomErrorWidget(),
//           data: (org) => InkWell(
//             onTap: () {
//               showOptionSheet();
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: data.thumbnail == null
//                                 ? Image.asset('assets/images/logo.png').image
//                                 : NetworkImage(getImageUrl(data.thumbnail!)),
//                             fit: BoxFit.cover),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   data.name ?? 'Unknow',
//                                   style: context.theme.textTheme.labelLarge
//                                       ?.copyWith(
//                                     fontSize: 18,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 15,
//                               ),
//                               Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(startDate),
//                                   Text(endDate),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             children: [
//                               const Text('Status: '),
//                               Text(data.isDisabled! ? 'Banned' : 'Active')
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Text('Manage by:'),
//                               Padding(
//                                 padding: const EdgeInsets.all(10),
//                                 child: CircleAvatar(
//                                   radius: 10,
//                                   backgroundImage: org.logo == null
//                                       ? Image.asset('assets/images/logo.png')
//                                           .image
//                                       : NetworkImage(getImageUrl(org.logo!)),
//                                 ),
//                               ),
//                               Text(org.name),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }