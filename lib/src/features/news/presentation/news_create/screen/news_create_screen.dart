import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:skeletons/skeletons.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/inline_editable_text/fom_builder_inline_editable_text.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/news_author.dart';
import 'package:the_helper/src/features/news/presentation/news/widget/news_organization_and_date.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/news_create_controller.dart';
import 'package:the_helper/src/features/news/presentation/news_create/widget/news_content_input.dart';
import 'package:the_helper/src/features/news/presentation/news_create/widget/news_create_bottom_bar.dart';
import 'package:the_helper/src/features/news/presentation/news_create/widget/news_thumbnail_input.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';
import 'package:the_helper/src/features/organization/domain/minimal_organization.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class NewsCreateScreen extends ConsumerWidget {
  const NewsCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationState = ref.watch(currentOrganizationServiceProvider);
    final profileState = ref.watch(profileProvider);
    final createNewsState = ref.watch(createNewsControllerProvider);

    ref.listen<AsyncValue>(
      createNewsControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: createNewsSnackbarName,
        );
      },
    );

    return LoadingOverlay.customDarken(
      isLoading: createNewsState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Creating news',
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create News'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: FormBuilder(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NewsThumbnailInput(),
                  const SizedBox(height: 24),
                  organizationState.when(
                    loading: () => const SkeletonLine(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (data) => NewsOrganizationAndDate(
                      organization: MinimalOrganization(
                        id: data!.id,
                        name: data.name,
                        logo: data.logo,
                      ),
                      publishedAt: DateTime.now(),
                      numericDates: false,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormBuilderInlineEditableText(
                    name: 'title',
                    initialValue: 'Your news title',
                    style: context.theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(100),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  profileState.when(
                    loading: () => const SkeletonLine(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (data) => NewsAuthor(
                      author: data,
                      authorPrefix: 'Author:',
                      navigateToProfileOnTap: false,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const NewsContentInput(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const NewsCreateBottomBar(),
      ),
    );
  }
}
