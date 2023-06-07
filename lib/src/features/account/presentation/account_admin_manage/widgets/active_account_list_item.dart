import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/controllers/account_manage_screen_controller.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/widgets/popup_menu_button.dart';
import 'package:the_helper/src/router/router.dart';
import '../../../../../common/widget/bottom_sheet/custom_modal_botton_sheet.dart';
import '../../../../../common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class ActiveAccountListItem extends ConsumerStatefulWidget {
  final AccountModel data;

  const ActiveAccountListItem({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<ActiveAccountListItem> createState() =>
      _ActiveAccountListItemState();
}

class _ActiveAccountListItemState extends ConsumerState<ActiveAccountListItem> {
  // show banned/unbanned dialog
  Future<dynamic> showBanDialog() {
    AccountModel account = widget.data;

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
            ref.read(scrollPagingControllerProvider.notifier).reloadPage();
            if (context.mounted) {
              print(res);
              context.pop();
            }
          }),
    );
  }

  // show delete dialog
  Future<dynamic> showDeleteDialog() {
    AccountModel account = widget.data;

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => ConfirmationDialog(
          titleText: 'Delete Account',
          content: RichText(
            text: TextSpan(
              text: 'Do you want to delete account',
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
                .delete(account.id!);
            ref.read(scrollPagingControllerProvider.notifier).reloadPage();
            if (context.mounted) {
              print(res);
              context.pop();
            }
          }),
    );
  }

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
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return CustomModalBottomSheet(
            titleText: widget.data.email,
            content: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: const Text('View profile'),
                  onTap: () => context.goNamed(AppRoute.profile.name),
                ),
                ListTile(
                  leading: const Icon(Icons.no_accounts_outlined),
                  title: const Text('Banned account'),
                  onTap: () {
                    context.pop();
                    showBanDialog();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.no_accounts_outlined),
                  title: const Text('Delete account'),
                  onTap: () {
                    context.pop();
                    showDeleteDialog();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            showOptionSheet();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text('A'),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data.email),
                  ],
                ),
              ),
              widget.data.isAccountVerified
                  ? Center(
                      child: Text(
                        'Verified',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.apply(color: Colors.green),
                      ),
                    )
                  : Center(
                      child: Text(
                        'Not verified',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.apply(color: Colors.red),
                      ),
                    ),
              PopupButton(accountId: widget.data.id)
            ],
          ),
        ));
  }
}