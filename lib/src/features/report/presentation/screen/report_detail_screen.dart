import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';

import 'package:the_helper/src/features/report/domain/report_model.dart';
import 'package:the_helper/src/features/report/presentation/controller/report_detail_controller.dart';
import 'package:the_helper/src/features/report/presentation/screen/report_reply_screen.dart';
import 'package:the_helper/src/features/report/presentation/widget/report_message_widget.dart';

import '../../../../common/widget/button/primary_button.dart';
import '../../../../common/widget/error_widget.dart';
import '../../../../utils/domain_provider.dart';
import '../widget/attached_files_list.dart';
import '../widget/avatar_watcher.dart';

class ReportDetailScreen extends ConsumerWidget {
  final int id;

  const ReportDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(reportDetailControllerProvider(id: id));
    // final customTileExpanded = ref.watch(expansionTitleControllerProvider);

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
        body: detail.when(
            error: (er, st) {
              print(er);
              print(st);
              return CustomErrorWidget(
                onRetry: () {
                  ref.invalidate(reportDetailControllerProvider);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (data) {
              var dateData = DateFormat("dd-mm-y HH:mm").format(data.createdAt);

              final reportedName = data.reportedAccount?.username ??
                  data.reportedAccount?.email ??
                  data.reportedOrganization?.name ??
                  data.reportedOrganization?.email ??
                  data.reportedActivity?.name;

              final avatarId = data.reportedAccount?.avatarId ??
                  data.reportedActivity?.thumbnail ??
                  data.reportedOrganization?.logo;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(Icons.schedule),
                              ),
                              Text(dateData),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AvatarWatcherWidget(avatarId: avatarId),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                reportedName!,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                          TextButton.icon(
                              onPressed: () {},
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(15)),
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      Theme.of(context).colorScheme.primary)),
                              icon: const Icon(Icons.visibility_outlined),
                              label: Text(
                                'Go to ${data.type}',
                              ))
                        ],
                      ),
                    ),
                    for (var i in data.messages) ReportMessageWidget(data: i),
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
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
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
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ReportReplyScreen(
                                          id: data.id!, title: data.title);
                                    },
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 25)),
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      Theme.of(context).colorScheme.onSurface)),
                              child: const Text('Reply'),
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
                                //     .verifyAccount(id: data.accountId!);
                                // if (context.mounted) {
                                //   context.pop();
                                // }
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 25)),
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      Theme.of(context).colorScheme.primary)),
                              child: const Text('Accept'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
