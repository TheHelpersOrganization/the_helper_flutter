import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/quill_editor_screen.dart';
import 'package:the_helper/src/common/widget/inline_editable_text.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/news_author.dart';
import 'package:the_helper/src/features/news/presentation/news/widget/news_organization_and_date.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/create_news_controller.dart';
import 'package:the_helper/src/features/news/presentation/news_create/widget/news_thumbnail_input.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';
import 'package:the_helper/src/features/organization/domain/minimal_organization.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';

class NewsCreateScreen extends ConsumerWidget {
  const NewsCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationState = ref.watch(currentOrganizationServiceProvider);
    final profileState = ref.watch(profileProvider);
    final controller = ref.watch(quillControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create News'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NewsThumbnailInput(),
              const SizedBox(height: 24),
              organizationState.when(
                loading: () => SkeletonListTile(
                  padding: EdgeInsets.zero,
                ),
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
              InlineEditableText(
                text: 'Your news title',
                style: context.theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              profileState.when(
                loading: () => SkeletonListTile(
                  padding: EdgeInsets.zero,
                ),
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
              Html(
                data: 'This is news content',
                style: {'body': Style(margin: Margins.zero)},
              ),
              TextButton(
                onPressed: () async {
                  final res = await context.navigator.push(
                    MaterialPageRoute(
                      builder: (context) => const QuillEditorScreen(
                        title: Text('Edit news content'),
                      ),
                    ),
                  );
                  print(res);
                },
                child: const Text('Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
