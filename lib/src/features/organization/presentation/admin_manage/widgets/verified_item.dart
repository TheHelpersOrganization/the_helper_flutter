import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/domain/organization_status.dart';

import '../../../../../common/widget/bottom_sheet/custom_modal_botton_sheet.dart';
import '../../../../../common/widget/dialog/confirmation_dialog.dart';
import '../../../../../common/widget/dialog/loading_dialog_content.dart';
import '../../../../../router/router.dart';
import '../controllers/organization_manage_screen_controller.dart';

class VerifiedListItem extends ConsumerStatefulWidget {
  final Organization data;
  final OrganizationStatus tabIndex;

  const VerifiedListItem({
    super.key,
    required this.data,
    required this.tabIndex,
  });

  @override
  ConsumerState<VerifiedListItem> createState() => _VerifiedListItemState();
}

class _VerifiedListItemState extends ConsumerState<VerifiedListItem> {
  Future<dynamic> showBanDialog() {
    Organization account = widget.data;

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => ConfirmationDialog(
          titleText: 'Ban Account',
          content: RichText(
            text: TextSpan(
              text: 'Do you want to ban this account',
              children: [
                TextSpan(
                  text: account.email,
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
                .watch(accountManageControllerProvider.notifier)
                .ban(account.id!);

            if (context.mounted) {
              print(res);
              context.pop();
            }
            ref.invalidate(scrollPagingControlNotifier(widget.tabIndex));
          }),
    );
  }

  // show delete dialog
  // Future<dynamic> showDeleteDialog() {
  //   AccountModel account = widget.data;

  //   return showDialog(
  //     context: context,
  //     useRootNavigator: false,
  //     builder: (dialogContext) => ConfirmationDialog(
  //         titleText: 'Delete Account',
  //         content: RichText(
  //           text: TextSpan(
  //             text: 'Do you want to delete account',
  //             children: [
  //               TextSpan(
  //                 text: account.email,
  //                 style: TextStyle(
  //                   color: context.theme.primaryColor,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         onConfirm: () async {
  //           context.pop();
  //           showLoadingDialog();
  //           final res = await ref
  //               .watch(accountManageControllerProvider.notifier)
  //               .delete(account.id!);
  //           if (context.mounted) {
  //             print(res);
  //             context.pop();
  //           }
  //           ref.invalidate(scrollPagingControlNotifier(widget.tabIndex));
  //         }),
  //   );
  // }

  // show loading dialog
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
    Organization org = widget.data;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return CustomModalBottomSheet(
            titleText: widget.data.email,
            content: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text('View profile'),
                  onTap: () {
                    context.pop();
                    context.pushNamed(
                      AppRoute.organization.name,
                      pathParameters: {
                        'orgId': org.id.toString(),
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.no_accounts_outlined),
                  title: const Text('Banned organization'),
                  onTap: () {
                    context.pop();
                    showBanDialog();
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.no_accounts_outlined),
                //   title: const Text('Delete account'),
                //   onTap: () {
                //     context.pop();
                //     showDeleteDialog();
                //   },
                // ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(color: Colors.black)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text('A'),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.data.name),
                        Text(widget.data.email),
                        RichText(
                          text: const TextSpan(
                              text:
                                  'Some location that the string is too long to fit in a card on flutter widget without break a new line'),
                          softWrap: false,
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.chevron_right)),
                ],
              ),
            ),
          )),
    );
  }
}
