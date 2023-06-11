import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/custom_sliver_scroll_view.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/image_picker_2/form_builder_image_picker.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/member.dart';

final _formKey = GlobalKey<FormBuilderState>();

class ModActivityCreationScreen extends ConsumerWidget {
  const ModActivityCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityManagersState = ref.watch(activityManagersProvider);
    final activityManagerSelection =
        ref.watch(activityManagerSelectionProvider);
    final createActivityState = ref.watch(createActivityControllerProvider);

    ref.listen<AsyncValue>(
      createActivityControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
      },
    );

    return LoadingOverlay(
      loadingOverlayType: LoadingOverlayType.custom,
      opacity: 0.8,
      isLoading: createActivityState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Creating activity',
      ),
      child: Scaffold(
        body: CustomSliverScrollView(
          appBar: CustomSliverAppBar(
            titleText: 'Create Activity',
            showBackButton: true,
            onBackFallback: () =>
                ref.read(routerProvider).goNamed(AppRoute.home.name),
            actions: const [],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Thumbnail'),
                      FormBuilderImagePicker(
                        name: 'thumbnail',
                        maxImages: 1,
                        maxWidth: context.mediaQuery.size.width,
                        previewWidth: context.mediaQuery.size.width,
                        previewHeight: (context.mediaQuery.size.width) / 16 * 9,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Pick an image',
                        ),
                        galleryLabel: const Text('Pick from Gallery'),
                        // availableImageSources: const [
                        //   ImageSourceOption.gallery,
                        // ],
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(
                        height: 32,
                        child: Divider(),
                      ),
                      Text(
                        'Basic Info',
                        style: context.theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(),
                      FormBuilderTextField(
                        name: 'name',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter activity name',
                          labelText: 'Name',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(50),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'description',
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: null,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(2000),
                        ]),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Description'),
                          hintText: 'Write about what your activity does',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Activity Managers',
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              _formKey.currentState!.save();
                              context.pushNamed(
                                AppRoute
                                    .organizationActivityCreationManagerChooser
                                    .name,
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Manager'),
                          )
                        ],
                      ),
                    ].padding(
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (activityManagerSelection.isNotEmpty)
                  activityManagersState.when(
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
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: activityManagerSelection.length,
                        itemBuilder: (context, index) {
                          final manager = data.activityManagers.firstWhere(
                              (element) =>
                                  element.accountId ==
                                  activityManagerSelection.elementAt(index));

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
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                              onPressed: () {
                                activityManagerSelection
                                    .remove(manager.accountId);
                                ref
                                    .read(activityManagerSelectionProvider
                                        .notifier)
                                    .state = {...activityManagerSelection};
                              },
                            ),
                            minVerticalPadding: 16,
                          );
                        },
                      );
                    },
                  ),
                const SizedBox(
                  height: 64,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (!_formKey.currentState!.saveAndValidate()) {
                          return;
                        }

                        final name =
                            _formKey.currentState!.fields['name']!.value;
                        final description =
                            _formKey.currentState!.fields['description']!.value;
                        final thumbnailValue =
                            _formKey.currentState!.fields['thumbnail']!.value;
                        Uint8List? thumbnail;
                        if (thumbnailValue != null) {
                          thumbnail =
                              (thumbnailValue as List<dynamic>).isNotEmpty
                                  ? thumbnailValue[0]
                                  : null;
                        }

                        ref
                            .read(createActivityControllerProvider.notifier)
                            .createActivity(
                              name: name,
                              description: description,
                              thumbnailData: thumbnail,
                              activityManagerIds:
                                  activityManagerSelection.toList(),
                            );
                      },
                      child: const Text('Create Activity'),
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
