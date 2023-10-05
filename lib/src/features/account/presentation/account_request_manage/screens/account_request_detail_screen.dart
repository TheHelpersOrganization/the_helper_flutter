import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/account/domain/account_request_query.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/controllers/account_request_detail_screen_controller.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/widgets/attached_files_list.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/widgets/note_dialog.dart';
import 'package:the_helper/src/features/profile/application/profile_service.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

import '../../../../../common/extension/image.dart';
import '../../../../../common/widget/button/primary_button.dart';
import '../../../../../common/widget/detail_list_tile.dart';
import '../../../../../common/widget/error_widget.dart';
import '../../../domain/account_request.dart';
import '../controllers/account_request_manage_screen_controller.dart';
import '../widgets/history_list_item.dart';

class AccountRequestDetailScreen extends ConsumerWidget {
  final int requestId;

  const AccountRequestDetailScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestData =
        ref.watch(accountRequestDetailControllerProvider(id: requestId));
    //Check if request has been reject before

    ref.listen<AsyncValue>(
      verifiedAccountControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        if (state.value != null) {
          state.showSnackbarOnSuccess(
            context,
            content: const Text('Verified account'),
          );
          ref.invalidate(scrollPagingControlNotifier);
        }
      },
    );

    return requestData.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stackTrace) => CustomErrorWidget(
              onRetry: () => ref.invalidate(
                  accountRequestDetailControllerProvider(id: requestId)),
            ),
        data: (requestData) {
          final profile = ref
              .watch(accountProfileServiceProvider(id: requestData.accountId!));
          final requestHistory = ref
              .watch(requestHistoryProvider(requestData.accountId!))
              .valueOrNull;
          List<AccountRequestModel> otherRequest = [];
          if (requestHistory != null) {
            otherRequest =
                requestHistory.filter((t) => t.id != requestData.id).toList();
          }
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
              body: profile.when(
                error: (_, __) => CustomErrorWidget(
                  onRetry: () {
                    ref.invalidate(accountRequestDetailControllerProvider);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (data) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 8,
                            color: Theme.of(context).primaryColor,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: data.avatarId == null
                                ? Image.asset(
                                    'assets/images/organization_placeholder.jpg',
                                  ).image
                                : ImageX.backend(
                                    data.avatarId!,
                                  ).image,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Text(
                        data.username!,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: ExpandableText(
                            data.bio!,
                            maxLines: 4,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            expandText: 'See More',
                            collapseText: 'See Less',
                            linkColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                      // Profile infomation
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User infomation',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            DetailListTile(
                                label: 'Email', value: data.email ?? 'Unknown'),
                            DetailListTile(
                                label: 'Phone Number',
                                value: data.phoneNumber ?? 'Unknown'),
                            DetailListTile(
                                label: 'First Name',
                                value: data.firstName ?? 'Unknown'),
                            DetailListTile(
                                label: 'Last Name',
                                value: data.lastName ?? 'Unknown'),
                            DetailListTile(
                                label: 'Date of Birth',
                                value: DateFormat('dd-MM-yyyy')
                                    .format(data.dateOfBirth!)),
                            DetailListTile(
                                label: 'Gender',
                                value: data.gender ?? 'Unknown'),
                          ],
                        ),
                      ),
                      // File attachment
                      requestData.files.isEmpty
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Attached files',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AttachedFilesList(files: requestData.files),
                                ],
                              ),
                            ),
                      requestData.note != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Request\'s note',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(requestData.note!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      otherRequest.isEmpty
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Account request history',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  for (var i in otherRequest)
                                    HistoryListItem(data: i)
                                ],
                              ),
                            ),
                      requestData.status == AccountRequestStatus.pending
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: PrimaryButton(
                                      // isLoading: state.isLoading,
                                      loadingText: "Processing...",
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          useRootNavigator: false,
                                          builder: (context) =>
                                              const NoteDialogWidget(),
                                        );
                                      },
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 25)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .error)),
                                      child: const Text('Reject'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.mediaQuery.size.width * 0.06,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: requestData.status ==
                                            AccountRequestStatus.blocked
                                        ? PrimaryButton(
                                            // isLoading: state.isLoading,
                                            loadingText: "Processing...",
                                            onPressed: () async {
                                              await ref
                                                  .watch(
                                                      verifiedAccountControllerProvider
                                                          .notifier)
                                                  .blockRequest(
                                                      requestId:
                                                          requestData.id!);
                                              if (context.mounted) {
                                                context.pop();
                                              }
                                            },
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 25)),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onSurface)),
                                            child: const Text('Unblock'),
                                          )
                                        : PrimaryButton(
                                            // isLoading: state.isLoading,
                                            loadingText: "Processing...",
                                            onPressed: () async {
                                              await ref
                                                  .watch(
                                                      verifiedAccountControllerProvider
                                                          .notifier)
                                                  .unblockRequest(
                                                      requestId:
                                                          requestData.id!);
                                              if (context.mounted) {
                                                context.pop();
                                              }
                                            },
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 25)),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onSurface)),
                                            child: const Text('Block'),
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
                                        await ref
                                            .watch(
                                                verifiedAccountControllerProvider
                                                    .notifier)
                                            .verifyAccount(
                                                accountId:
                                                    requestData.accountId!);
                                        if (context.mounted) {
                                          context.pop();
                                        }
                                      },
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 25)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary)),
                                      child: const Text('Accept'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ));
        });
  }
}
