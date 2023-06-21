import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/controllers/account_request_detail_screen_controller.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/widgets/attached_files_list.dart';
import 'package:the_helper/src/features/profile/application/profile_service.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/widgets/note_dialog.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

import '../../../../../common/extension/image.dart';
import '../../../../../common/widget/button/primary_button.dart';
import '../../../../../common/widget/detail_list_tile.dart';
import '../../../../../common/widget/error_widget.dart';
import '../../../domain/account_request.dart';

class AccountRequestDetailScreen extends ConsumerWidget {
  final AccountRequestModel requestData;

  const AccountRequestDetailScreen({super.key, required this.requestData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile =
        ref.watch(accountProfileServiceProvider(id: requestData.accountId!));
    // final customTileExpanded = ref.watch(expansionTitleControllerProvider);
    //Check if request has been reject before
     
    ref.listen<AsyncValue>(
      accountRequestDetailControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        if (state.value != null) {
          state.showSnackbarOnSuccess(
            context,
            content: const Text('Verified account'),
          );
        }
      },
    );

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
                  style: Theme.of(context).textTheme.displayLarge,
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
                      linkColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
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
                          label: 'Gender', value: data.gender ?? 'Unknown'),
                    ],
                  ),
                ),
                // File attachment
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                      AttachedFilesList(files: requestData.files),
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              useRootNavigator: false, 
                              builder: (context) => const NoteDialogWidget(),
                            );
                          },
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
                            await ref
                                .watch(accountRequestDetailControllerProvider
                                    .notifier)
                                .verifyAccount(id: requestData.accountId!);
                            if (context.mounted) {
                              context.pop();
                            }
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
        ));
  }
}
