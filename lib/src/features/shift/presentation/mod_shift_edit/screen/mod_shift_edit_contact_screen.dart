import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/shift/domain/update_shift.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/controller/shift_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_creation_contact_view.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_edit/controller/edit_shift_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class ModShiftEditContactScreen extends ConsumerWidget {
  final int activityId;
  final int shiftId;

  const ModShiftEditContactScreen({
    super.key,
    required this.activityId,
    required this.shiftId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extendedActivityState =
        ref.watch(getActivityAndShiftProvider(shiftId));
    final updateShiftState = ref.watch(updateShiftControllerProvider);
    final selectedContacts = ref.watch(selectedContactIdsProvider);

    ref.listen<AsyncValue>(
      updateShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Shift updated successfully'),
        );
      },
    );

    return LoadingOverlay(
      isLoading: updateShiftState.isLoading,
      loadingOverlayType: LoadingOverlayType.custom,
      indicator: const LoadingDialog(
        titleText: 'Updating shift',
      ),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverAppBar(
              title: Text('Edit shift contacts'),
              floating: true,
            ),
          ],
          body: extendedActivityState.when(
            skipLoadingOnRefresh: false,
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => CustomErrorWidget(
              onRetry: () => ref.invalidate(getActivityAndShiftProvider),
            ),
            data: (data) {
              if (data == null || data.shift.activityId != activityId) {
                return const DevelopingScreen();
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ShiftCreationContactView(
                    initialContacts:
                        data.shift.contacts?.map((e) => e.id!).toSet(),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: extendedActivityState.isLoading
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    height: 1,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            // Can skip skill step and manager step
                            child: TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text('Cancel'),
                            )),
                        Expanded(
                          flex: 3,
                          child: FilledButton(
                            onPressed: () {
                              final shift = UpdateShift(
                                contacts: selectedContacts?.toList(),
                              );
                              ref
                                  .read(updateShiftControllerProvider.notifier)
                                  .updateShift(id: shiftId, shift: shift);
                            },
                            child: const Text(
                              'Save',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
