import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/custom_sliver_scroll_view.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/member.dart';

class ModActivityManagerChooser extends ConsumerWidget {
  const ModActivityManagerChooser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityManagersState = ref.watch(activityManagersProvider);
    final activityManagerSelection =
        ref.watch(activityManagerSelectionProvider);

    return Scaffold(
      body: CustomSliverScrollView(
        appBar: CustomSliverAppBar(
          titleText: 'Managers',
          centerTitle: false,
          showBackButton: true,
          actions: [
            TextButton.icon(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.check),
              label: const Text('Save'),
            ),
            const SizedBox(
              width: 12,
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(84),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: DebounceSearchBar(),
            ),
          ),
        ),
        body: activityManagersState.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => CustomErrorWidget(
            onRetry: () {
              ref.invalidate(activityManagersProvider);
            },
          ),
          data: (data) => ListView.builder(
            itemCount: data.activityManagers.length,
            itemBuilder: (context, index) {
              final manager = data.activityManagers[index];

              return Consumer(
                builder: (context, ref, child) {
                  return ListTile(
                    title: Text(getMemberName(manager)),
                    subtitle: manager.accountId == data.account.id
                        ? const Text('Your account')
                        : null,
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        getImageUrl(manager.profile!.avatarId!),
                      ),
                    ),
                    onTap: () {
                      final value =
                          activityManagerSelection.contains(manager.accountId);
                      if (value == true) {
                        activityManagerSelection.remove(manager.accountId);
                        ref
                            .read(activityManagerSelectionProvider.notifier)
                            .state = {...activityManagerSelection};
                      } else {
                        ref
                            .read(activityManagerSelectionProvider.notifier)
                            .update((state) => {...state, manager.accountId});
                      }
                    },
                    trailing: Checkbox(
                      value:
                          activityManagerSelection.contains(manager.accountId),
                      onChanged: (value) {
                        if (value == true) {
                          ref
                              .read(activityManagerSelectionProvider.notifier)
                              .update((state) => {...state, manager.accountId});
                        } else {
                          activityManagerSelection.remove(manager.accountId);
                          ref
                              .read(activityManagerSelectionProvider.notifier)
                              .state = {...activityManagerSelection};
                        }
                      },
                    ),
                    minVerticalPadding: 16,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
