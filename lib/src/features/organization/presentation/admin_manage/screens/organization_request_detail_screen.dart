import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/common/widget/detail_list_tile.dart';
import 'package:the_helper/src/features/organization/domain/organization_status.dart';
import 'package:the_helper/src/features/organization/presentation/admin_manage/controllers/organization_manage_screen_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
import 'package:the_helper/src/utils/location.dart';

import '../../../domain/admin_organization.dart';
import '../widgets/attached_files_list.dart';


class OrganizationRequestDetailScreen extends ConsumerWidget {
  final AdminOrganization data;

  const OrganizationRequestDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Check if request has been reject before

    ref.listen<AsyncValue>(
      organizatonManageControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        if (state.value != null) {
          state.showSnackbarOnSuccess(
            context,
            content: const Text('Verified organization'),
          );
          ref.invalidate(requestScrollPagingControlNotifier);
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
        title: const Text('Organization request'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                  image: data.logo == null
                      ? Image.asset(
                          'assets/images/organization_placeholder.jpg',
                        ).image
                      : ImageX.backend(
                          data.logo!,
                        ).image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Text(
              data.name,
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
                  data.description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  expandText: 'See More',
                  collapseText: 'See Less',
                  linkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            // Profile infomation
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Organization infomation',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  DetailListTile(label: 'Email', value: data.email),
                  DetailListTile(
                      label: 'Phone number', value: data.phoneNumber),
                  DetailListTile(label: 'Website', value: data.website),
                ],
              ),
            ),
            data.locations != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Location',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...data.locations!
                      .map((e) => ListTile(
                            title: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.location_city),
                                Flexible(
                                    child: Text(
                                  getAddress(e),
                                  textAlign: TextAlign.end,
                                )),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              )
            : const SizedBox(),
            data.contacts != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Contact',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...data.contacts!
                      .map((e) => ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(e.name),
                            trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(e.phoneNumber ?? 'None',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge),
                                  Text(e.email ?? 'None',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge)
                                ]),
                          ))
                      .toList(),
                ],
              )
            : const SizedBox(),
            // File attachment
            data.files.isEmpty
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
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  AttachedFilesList(files: data.files),
                ],
              ),
            ),
            data.status == OrganizationStatus.pending
            ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: PrimaryButton(
                      // isLoading: state.isLoading,
                      loadingText: "Processing...",
                      onPressed: () async {
                        await ref
                            .watch(organizatonManageControllerProvider
                                .notifier)
                            .reject(
                                data.id!);
                        if (context.mounted) {
                          context.pop();
                        }
                      },
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
                      // isLoading: profile.isLoading,
                      loadingText: "Processing...",
                      onPressed: () async {
                        await ref
                            .watch(organizatonManageControllerProvider
                                .notifier)
                            .approve(
                                data.id!);
                        if (context.mounted) {
                          context.pop();
                        }
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 25)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.primary)),
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
    );
  }
}
