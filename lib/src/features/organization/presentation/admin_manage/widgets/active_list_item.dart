import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/bottom_sheet/custom_modal_botton_sheet.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

import '../../../domain/admin_organization.dart';
import '../controllers/organization_manage_screen_controller.dart';

class ActiveOrganizationListItem extends ConsumerStatefulWidget {
  final AdminOrganization data;

  const ActiveOrganizationListItem({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<ActiveOrganizationListItem> createState() =>
      _ActiveOrganizationListItemState();
}

class _ActiveOrganizationListItemState
    extends ConsumerState<ActiveOrganizationListItem> {
  // show banned/unbanned dialog
  Future<dynamic> showBanDialog() {
    AdminOrganization organization = widget.data;

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => ConfirmationDialog(
          titleText: 'Ban organization',
          content: RichText(
            text: TextSpan(
              text: 'Do you want to ban this organization',
              children: [
                TextSpan(
                  text: organization.name,
                  style: TextStyle(
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          onConfirm: () async {
            context.pop();
            showLoadingDialog();
            final res = await ref
                .watch(organizatonManageControllerProvider.notifier)
                .ban(organization.id!);

            if (context.mounted) {              
              context.pop();
              if (res == null) {
                showErrorDialog();
              }
            }
            ref.invalidate(scrollPagingControlNotifier(false));
          }),
    );
  }

  void showErrorDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: false,
        builder: (dialogContext) => SimpleDialog(
          alignment: Alignment.center,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          children: [
            Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  color: dialogContext.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            FilledButton(
              onPressed: () {
                dialogContext.pop();
              },
              child: const Text('Ok'),
            ),
          ],
        ));
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (context) => const LoadingDialog(
        titleText: 'Processing...',
      ),
    );
  }

  // show option sheet
  void showOptionSheet() {
    AdminOrganization organization = widget.data;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return CustomModalBottomSheet(
            titleText: widget.data.email,
            content: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: const Text('View organization'),
                  onTap: () {
                    context.pop();
                    context.pushNamed(
                      AppRoute.organization.name,
                      pathParameters: {
                        'orgId': organization.id.toString(),
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.no_accounts_outlined),
                  title: const Text('Ban organization'),
                  onTap: () {
                    context.pop();
                    showBanDialog();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final organization = widget.data;
    var fileNum = organization.files.length;
    return Container(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: InkWell(
          onTap: () => showOptionSheet(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundImage: organization.logo == null
                        ? Image.asset('assets/images/logo.png').image
                        : NetworkImage(getImageUrl(organization.logo!)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          organization.name,
                          style: context.theme.textTheme.labelLarge?.copyWith(
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          organization.email,
                          // style: context.theme.textTheme.labelLarge
                          //     ?.copyWith(
                          //   fontSize: 18,
                          // ),
                          // overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          organization.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // RichText(
                        //   text: TextSpan(
                        //     text: data.note,
                        //   ),
                        //   softWrap: false,
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        fileNum != 0
                            ? Text("Attached file(s): $fileNum")
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
