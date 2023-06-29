import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

import 'package:the_helper/src/features/report/domain/admin_report.dart';

import '../../../../common/widget/button/primary_button.dart';
import '../widget/attached_files_list.dart';

class ReportDetailScreen extends ConsumerWidget {
  final AdminReportModel reportData;

  const ReportDetailScreen({super.key, required this.reportData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final profile =
    //     ref.watch(accountProfileServiceProvider(id: requestData.accountId!));
    // final customTileExpanded = ref.watch(expansionTitleControllerProvider);
    var dateData = DateFormat("hh:mm - MMM d, y").format(reportData.createdAt);
    // ref.listen<AsyncValue>(
    //   accountRequestDetailControllerProvider,
    //   (_, state) {
    //     state.showSnackbarOnError(context);
    //     if(state.value != null){
    //       state.showSnackbarOnSuccess(
    //       context,
    //       content: const Text('Verified account'),
    //     );}
    //   },
    // );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Verified request'),
        centerTitle: true,
      ),
      body:
          // profile.when(
          //   error: (_, __) => CustomErrorWidget(
          //     onRetry: () {
          //       ref.invalidate(accountRequestDetailControllerProvider);
          //     },
          //   ),
          //   loading: () => const Center(child: CircularProgressIndicator()),
          //   data: (data) =>
          SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Container(
            //   height: 300,
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       width: 8,
            //       color: Theme.of(context).primaryColor,
            //     ),
            //     shape: BoxShape.circle,
            //     image: DecorationImage(
            //       image: data.avatarId == null
            //           ? Image.asset(
            //               'assets/images/organization_placeholder.jpg',
            //             ).image
            //           : ImageX.backend(
            //               data.avatarId!,
            //             ).image,
            //       fit: BoxFit.fitHeight,
            //     ),
            //   ),
            // ),
            Text(
              // reportData.accusedName,
              'sdfád',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.schedule),
                ),
                Text(dateData),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // reportData.reportType,
                    'ádfaèad',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.blue),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.all(15)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary)),
                    icon: const Icon(Icons.visibility_outlined), 
                    label: Text(
                      'Go to ${reportData.type}',
                    )
                  )
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Additionall infomation',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    // reportData.note
                    null
                    ?? 'There \'s no report\'s note',
                    style: Theme.of(context)
                    .textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // File attachment
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Attached files',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  // AttachedFilesList(files: reportData.files),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: PrimaryButton(
                      // isLoading: state.isLoading,
                      loadingText: "Processing...",
                      onPressed: () {},
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 25)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.error)),
                      child: const Text('Reject'),
                    ),
                  ),
                  SizedBox(
                    width: context.mediaQuery.size.width * 0.06,
                  ),
                  Expanded(
                    flex: 1,
                    child: PrimaryButton(
                      // isLoading: profile.isLoading,
                      loadingText: "Processing...",
                      onPressed: () async {
                        // await ref
                        //     .watch(accountRequestDetailControllerProvider
                        //         .notifier)
                        //     .verifyAccount(id: reportData.accountId!);
                        // if (context.mounted) {
                        //   context.pop();
                        // }
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 25)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // )
    );
  }
}
