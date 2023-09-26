import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/common/widget/search_bar/river_debounce_search_bar.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_grant/controller/account_admin_grant_controller.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_grant/widget/account_admin_admin_tab.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_grant/widget/account_admin_non_admin_tab.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class AccountAdminGrantScreen extends ConsumerWidget {
  const AccountAdminGrantScreen({super.key});

  final tabs = const [
    Tab(text: 'Admin'),
    Tab(text: 'Non-admin'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grantAdminControllerState = ref.watch(grantAdminControllerProvider);
    final revokeAdminControllerState = ref.watch(revokeAdminControllerProvider);
    final TextEditingController textEditingController =
        ref.watch(textEditingControllerProvider);
    ref.listen(grantAdminControllerProvider, (previous, next) {
      next.showSnackbarOnSuccess(
        context,
        content: const Text('Admin granted'),
        name: grantAdminSnackbarName,
      );
      next.showSnackbarOnError(context, name: grantAdminSnackbarName);
    });

    ref.listen(revokeAdminControllerProvider, (previous, next) {
      next.showSnackbarOnSuccess(
        context,
        content: const Text('Admin revoked'),
        name: revokeAdminSnackbarName,
      );
      next.showSnackbarOnError(context, name: revokeAdminSnackbarName);
    });

    return LoadingOverlay.customDarken(
      isLoading: grantAdminControllerState.isLoading ||
          revokeAdminControllerState.isLoading,
      indicator: const LoadingDialog(),
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(
            title: const Text('Admin management'),
            bottom: TabBar(tabs: tabs),
          ),
          body: Builder(builder: (context) {
            final tabController = DefaultTabController.of(context);
            tabController.addListener(() {
              ref.read(accountAdminGrantSearchPatternProvider.notifier).state =
                  '';
              textEditingController.clear();
            });

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: RiverDebounceSearchBar.autoDispose(
                    controller: textEditingController,
                    provider: accountAdminGrantSearchPatternProvider,
                    hintText: 'Search by name or email',
                  ),
                ),
                const Expanded(
                  child: TabBarView(children: [
                    AccountAdminAdminTab(),
                    AccountAdminNonAdminTab(),
                  ]),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
