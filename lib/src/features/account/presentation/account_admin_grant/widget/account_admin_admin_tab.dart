import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_grant/controller/account_admin_grant_controller.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class AccountAdminAdminTab extends ConsumerWidget {
  const AccountAdminAdminTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountId = ref.watch(authServiceProvider).asData?.value?.account.id;
    return RiverPagedBuilder<int, AccountModel>.autoDispose(
      provider: adminAccountListPagedNotifierProvider,
      pagedBuilder: (controller, builder) => PagedListView(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) {
        if (item.id == accountId) {
          return const SizedBox();
        }
        final name = getProfileName(item.profile);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                getBackendImageOrLogoProvider(item.profile!.avatarId),
          ),
          title: Text(name),
          subtitle: Text(item.profile?.username ?? item.email),
          trailing: TextButton.icon(
            icon: const Icon(Icons.remove),
            label: const Text('Revoke'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ConfirmationDialog(
                  titleText: 'Revoke admin',
                  content: Text(
                    'Are you sure you want to revoke admin role from account $name?',
                  ),
                  onConfirm: () {
                    ref
                        .read(revokeAdminControllerProvider.notifier)
                        .revokeAdmin(item.id!);
                  },
                ),
              );
            },
          ),
          onTap: () {},
        );
      },
      firstPageKey: 0,
    );
  }
}
