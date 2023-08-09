import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/features/organization/data/mod_organization_repository.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class OrganizationOption {
  final int id;
  final String name;
  final int? logoId;
  final bool isCurrent;
  final bool lastItem;

  const OrganizationOption({
    required this.id,
    required this.name,
    this.logoId,
    this.isCurrent = false,
    this.lastItem = false,
  });
}

class SwitchOrganizationDialog extends ConsumerWidget {
  const SwitchOrganizationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      switchOrganizationControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
      },
    );
    final router = ref.watch(routerProvider);
    final organizations = ref.watch(getOwnedOrganizationsProvider);
    final currentOrganization = ref.watch(currentOrganizationProvider);
    final isLoading = organizations.isLoading || currentOrganization.isLoading;
    final hasError = organizations.hasError || currentOrganization.hasError;
    final radioSelectedOrganizationId = ref.watch(selectedOrganization);
    final switchState = ref.watch(switchOrganizationControllerProvider);

    final List<OrganizationOption> options = [];
    if (!isLoading && !hasError) {
      final selected = currentOrganization.valueOrNull;
      if (selected != null) {
        options.add(
          OrganizationOption(
            id: selected.id,
            name: selected.name,
            logoId: selected.logo,
            isCurrent: true,
          ),
        );
      }

      final values = organizations.valueOrNull!;
      for (final value in values) {
        if (selected != null && value.id == selected.id) {
          continue;
        }
        options.add(
          OrganizationOption(
            id: value.id,
            name: value.name,
            logoId: value.logo,
          ),
        );
      }
    }

    final Widget child;
    if (isLoading) {
      child = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (hasError) {
      child = const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            'An error has happened',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      );
    } else {
      child = SingleChildScrollView(
        child: Column(
          children: [
            Column(
            children:options.map(
            (e) {
              final bool isSelected;
              if (radioSelectedOrganizationId != null) {
                isSelected = e.id == radioSelectedOrganizationId;
              } else {
                isSelected = e.isCurrent;
              }
              return RadioListTile<int>(
                value: e.id,
                groupValue: radioSelectedOrganizationId,
                onChanged: switchState.isLoading
                    ? null
                    : (int? option) {
                        ref.read(selectedOrganization.notifier).state = option;
                      },
                selected: isSelected,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(
                  e.name,
                ),
                subtitle: e.isCurrent
                    ? const Text(
                        'Currently selected',
                      )
                    : null,
              );
            },
          ).toList()),
          ListTile(
            selected: true,
            dense: true,
            title: const Text('Make a new one'),
            leading: const Icon(Icons.add),
            onTap: () => context.goNamed(AppRoute.organizationRegistration.name),
          )],
        ),
      );
    }

    return AlertDialog(
      //contentPadding: const EdgeInsets.all(12),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Choose organization',
              style: context.theme.textTheme.titleLarge,
            ),
          ),
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: child,
          ),
          const SizedBox(
            height: 12,
          ),
          const Divider(),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: FilledButton(
                  onPressed: radioSelectedOrganizationId == null ||
                          radioSelectedOrganizationId ==
                              currentOrganization.valueOrNull?.id
                      ? null
                      : () async {
                          context.pop();
                          _showLoadingDialog(
                            context,
                            options
                                .firstWhere(
                                  (element) =>
                                      element.id == radioSelectedOrganizationId,
                                )
                                .name,
                          );
                          final res = await ref
                              .read(
                                  switchOrganizationControllerProvider.notifier)
                              .switchOrganization(radioSelectedOrganizationId);
                          if (res == null) {
                            // Something when wrong
                            return;
                          }

                          router.pop();
                          router.goNamed(AppRoute.home.name);
                        },
                  child: const Text('Switch'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

void _showLoadingDialog(BuildContext context, String organizationName) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (context) => LoadingDialog(
      titleText: 'Switching to $organizationName...',
    ),
  );
}
