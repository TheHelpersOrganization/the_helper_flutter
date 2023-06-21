import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/widgets/attached_files_list.dart';

import '../../../../../common/domain/file_info.dart';
import '../../../../../common/extension/image.dart';
import '../../../../../common/widget/button/primary_button.dart';
import '../../../../profile/presentation/profile_controller.dart';

// import '../../../common/widget/button/primary_button.dart';
// import '../domain/profile.dart';
List<FileInfoModel> files = [
  FileInfoModel(
      name: "Filename",
      internalName: "internalName",
      mimetype: "mimetype",
      size: 200,
      sizeUnit: "sizeUnit"),
  FileInfoModel(
      name: "ADF",
      internalName: "internalName",
      mimetype: "mimetype",
      size: 20,
      sizeUnit: "sizeUnit"),
];

class AccountRequestDetailScreen extends ConsumerWidget {
  // final int requestId;

  const AccountRequestDetailScreen({
    super.key,
    // required this.requestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider());
    // final customTileExpanded = ref.watch(expansionTitleControllerProvider);

    // ref.listen<AsyncValue>(
    //   profileVerifiedRequestControllerProvider,
    //   (_, state) {
    //     state.showSnackbarOnError(context);
    //     state.showSnackbarOnSuccess(
    //       context,
    //       content: const Text('Verified request send'),
    //     );
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
        body: profile.when(
          error: (error, stacktrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (profile) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Profile header
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 8,
                          color: Theme.of(context).primaryColor,
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: profile.avatarId == null
                              ? Image.asset(
                                  'assets/images/organization_placeholder.jpg',
                                ).image
                              : ImageX.backend(
                                  profile.avatarId!,
                                ).image,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Text(
                      profile.username!,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     padding: const EdgeInsets.all(16.0),
                    //     // alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: Theme.of(context).colorScheme.secondary,
                    //       borderRadius: const BorderRadius.all(
                    //         Radius.circular(20),
                    //       ),
                    //     ),
                    //     child: ExpandableText(
                    //       profile.bio!,
                    //       maxLines: 4,
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //         color: Theme.of(context).colorScheme.onSecondary,
                    //       ),
                    //       expandText: 'See More',
                    //       collapseText: 'See Less',
                    //       linkColor:
                    //           Theme.of(context).colorScheme.onPrimaryContainer,
                    //     ),
                    //   ),
                    // ),
                    // Profile infomation
                    // DetailListTile(
                    //     label: 'Phone Number',
                    //     value: profile.phoneNumber ?? 'Unknown'),
                    // DetailListTile(
                    //     label: 'First Name',
                    //     value: profile.firstName ?? 'Unknown'),
                    // DetailListTile(
                    //     label: 'Last Name',
                    //     value: profile.lastName ?? 'Unknown'),
                    // DetailListTile(
                    //     label: 'Date of Birth',
                    //     value: DateFormat('dd-MM-yyyy')
                    //         .format(profile.dateOfBirth!)),
                    // DetailListTile(
                    //     label: 'Gender', value: profile.gender ?? 'Unknown'),
                    // File attachment
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AttachedFilesList(files: files),
                    ),
                    Row(
                      children: [
                        PrimaryButton(
                          // isLoading: state.isLoading,
                          loadingText: "Processing...",
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.error)),
                          child: const Text('Reject'),
                        ),
                        PrimaryButton(
                          // isLoading: profile.isLoading,
                          loadingText: "Processing...",
                          onPressed: () async {},
                          child: const Text('Accept'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
