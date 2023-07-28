import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/controllers/account_manage_screen_controller.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/widgets/popup_menu_button.dart';
import 'package:the_helper/src/features/profile/application/profile_service.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import '../../../../../common/widget/bottom_sheet/custom_modal_botton_sheet.dart';
import '../../../../../common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class BannedAccountListItem extends ConsumerStatefulWidget {
  final AccountModel data;
  final int tabIndex;

  const BannedAccountListItem({
    super.key,
    required this.data,
    required this.tabIndex,
  });

  @override
  ConsumerState<BannedAccountListItem> createState() =>
      _BannedAccountListItemState();
}

class _BannedAccountListItemState extends ConsumerState<BannedAccountListItem> {
  // show banned/unbanned dialog
  Future<dynamic> showUnbanDialog() {
    AccountModel account = widget.data;

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => ConfirmationDialog(
          titleText: 'Unban Account',
          content: RichText(
            text: TextSpan(
              text: 'Do you want to unban this account',
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
                .unban(account.id!);
            if (context.mounted) {
              if (res == null) {
                showErrorDialog();
              }
              context.pop();
            }
            ref.invalidate(scrollPagingControlNotifier(widget.tabIndex));
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
            if (context.mounted) {
              if (res == null) {
                showErrorDialog();
              }
              context.pop();
            }
            ref.invalidate(scrollPagingControlNotifier(widget.tabIndex));
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
    AccountModel account = widget.data;
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
                  onTap: () {
                    context.pop();
                    context.pushNamed(
                      AppRoute.otherProfile.name,
                      pathParameters: {
                        'userId': account.id.toString(),
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.no_accounts_outlined),
                  title: const Text('Unban account'),
                  onTap: () {
                    context.pop();
                    showUnbanDialog();
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
    final profile = ref.watch(accountProfileServiceProvider(id: widget.data.id!));
    return Container(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: InkWell(
            onTap: () {
              showOptionSheet();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: profile.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (_, __) => const CustomErrorWidget(),
                    data: (data) => CircleAvatar(
                    backgroundImage: data.avatarId == null
                        ? Image.asset('assets/images/logo.png').image
                        : CachedNetworkImageProvider(getImageUrl(data.avatarId!)),
                  ),
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
          )),
    );
  }
}
