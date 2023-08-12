import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/organization/domain/organization_transfer_ownership.dart';
import 'package:the_helper/src/features/organization/presentation/organization_transfer_ownership/controller/organization_transfer_ownership_controller.dart';
import 'package:the_helper/src/features/organization_member/data/mod_organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/get_organization_member_query.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member_status.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class OrganizationTransferOwnershipScreen extends ConsumerWidget {
  const OrganizationTransferOwnershipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDataState =
        ref.watch(organizationTransferOwnershipDataProvider);
    final organizationTransferOwnershipState =
        ref.watch(organizationTransferOwnershipControllerProvider);
    final selectedMember = ref.watch(selectedMemberProvider);
    final controller = ref.watch(passwordControllerProvider);

    ref.listen<AsyncValue>(
      organizationTransferOwnershipControllerProvider,
      (previous, next) {
        next.showSnackbarOnError(
          context,
          name: transferOwnershipSnackbarName,
        );
        next.showSnackbarOnSuccess(
          context,
          content: const Text('Transfer Ownership Success'),
          name: transferOwnershipSnackbarName,
        );
      },
    );

    return LoadingOverlay.customDarken(
      isLoading: organizationTransferOwnershipState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Transferring ownership',
      ),
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Transfer Ownership'),
        ),
        body: screenDataState.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const CustomErrorWidget(
              // onRetry: () => ref.invalidate(currentOrganizationServiceProvider),
              ),
          data: (screenData) {
            final organization = screenData.currentOrganization;
            final myMember = screenData.myMember;

            return Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundImage: getBackendImageOrLogoProvider(
                          organization.logo,
                        ),
                      ),
                      title: Text(
                        organization.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text('This organization'),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '1. The new owner must be a member of this organization.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '2. You will be degrade to Organization Manager.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                        'That means you will lose permissions to delete this organization and manage its verification.'),
                    const SizedBox(height: 12),
                    const Text(
                      '3. You can\'t undo this action.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 36),
                    const Text(
                      'Select the new owner',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (selectedMember != null)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundImage: getBackendImageOrLogoProvider(
                            selectedMember.profile!.avatarId,
                          ),
                        ),
                        title: Text(
                          getProfileName(selectedMember.profile!),
                        ),
                        subtitle: Text(
                          selectedMember.roles?.firstOrNull?.displayName ??
                              'Member',
                          style: TextStyle(
                            color: context.theme.colorScheme.secondary,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            ref.read(selectedMemberProvider.notifier).state =
                                null;
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    if (selectedMember == null)
                      FormBuilderTypeAhead<OrganizationMember>(
                        name: 'member',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Search for a member',
                          prefixIcon: Icon(Icons.search),
                        ),
                        suggestionsCallback: (text) async {
                          return ref
                              .read(modOrganizationMemberRepositoryProvider)
                              .getMemberWithAccountProfile(
                                organization.id,
                                query: GetOrganizationMemberQuery(
                                  notId: [myMember.id],
                                  name:
                                      text.trim().isEmpty ? null : text.trim(),
                                  statuses: [OrganizationMemberStatus.approved],
                                  limit: 5,
                                ),
                              );
                        },
                        onSuggestionSelected: (suggestion) => ref
                            .read(selectedMemberProvider.notifier)
                            .state = suggestion,
                        selectionToTextTransformer: (suggestion) =>
                            getProfileName(suggestion.profile!),
                        itemBuilder: (context, item) {
                          final profile = item.profile!;
                          final roleName = item.roles?.firstOrNull?.displayName;
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: getBackendImageOrLogoProvider(
                                profile.avatarId,
                              ),
                            ),
                            title: Text(getProfileName(profile)),
                            subtitle: roleName == null
                                ? null
                                : Text(
                                    roleName,
                                    style: TextStyle(
                                      color:
                                          context.theme.colorScheme.secondary,
                                    ),
                                  ),
                          );
                        },
                      ),
                    const SizedBox(height: 12),
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Type your password to continue',
                        prefixIcon: Icon(Icons.key),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: selectedMember == null
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  titleText: 'Transfer Ownership',
                                  content: const Text(
                                    'Are you sure you want to transfer ownership?',
                                  ),
                                  onConfirm: () {
                                    final password = controller.text;
                                    context.pop();
                                    controller.clear();

                                    ref
                                        .read(
                                            organizationTransferOwnershipControllerProvider
                                                .notifier)
                                        .transferOwnership(
                                          organizationId: organization.id,
                                          data: OrganizationTransferOwnership(
                                            memberId: selectedMember.id,
                                            password: password,
                                          ),
                                        );
                                  },
                                ),
                              );
                            },
                      child: const Text('Transfer Ownership'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
