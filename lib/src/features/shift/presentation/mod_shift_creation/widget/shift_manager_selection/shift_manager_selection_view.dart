import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_manager_selection/selected_managers.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_manager_selection/unselected_managers.dart';

class ShiftManagerSelectionView extends ConsumerWidget {
  const ShiftManagerSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftManagerDataState = ref.watch(memberDataProvider);
    final selectedManagers = ref.watch(selectedManagersProvider);

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
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(84),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: DebounceSearchBar(),
                ),
              ),
            ),
          ];
        },
        body: shiftManagerDataState.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => CustomErrorWidget(
            onRetry: () {
              ref.invalidate(memberDataProvider);
            },
          ),
          data: (data) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectedManagers(
                    selectedManagers: selectedManagers,
                    managers: data.managers,
                    myAccount: data.account,
                  ),
                  UnselectedManagers(
                    selectedManagers: selectedManagers,
                    managers: data.managers,
                    myAccount: data.account,
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
