import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/search_bar/river_debounce_search_bar.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_manager/selected_managers.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_manager/unselected_managers.dart';

class ActivityManagerSelectionView extends ConsumerWidget {
  final Set<int>? initialManagers;

  const ActivityManagerSelectionView({
    super.key,
    this.initialManagers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPattern = ref.watch(activityManagerSearchPatternProvider);
    final activityManagersState = ref.watch(activityManagersProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CustomSliverAppBar(
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(90),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: RiverDebounceSearchBar.autoDispose(
                    provider: activityManagerSearchPatternProvider,
                  ),
                ),
              ),
            ),
          ];
        },
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
          data: (data) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectedManagers(
                    managers: data.managers,
                    myAccount: data.account,
                    initialManagers: initialManagers,
                  ),
                  UnselectedManagers(
                    managers: data.managers,
                    searchPattern: searchPattern,
                    myAccount: data.account,
                    initialManagers: initialManagers,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
