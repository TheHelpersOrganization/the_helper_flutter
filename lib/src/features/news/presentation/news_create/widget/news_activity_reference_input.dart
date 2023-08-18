import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:the_helper/src/features/activity/data/mod_activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/minimal_activity.dart';
import 'package:the_helper/src/features/activity/domain/mod_activity_query.dart';
import 'package:the_helper/src/features/news/presentation/news/widget/news_activity.dart';
import 'package:the_helper/src/features/news/presentation/news_create/controller/news_create_controller.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';
import 'package:the_helper/src/utils/image.dart';

class NewsActivityReferenceInput extends ConsumerStatefulWidget {
  final MinimalActivity? initialValue;

  const NewsActivityReferenceInput({
    super.key,
    this.initialValue,
  });

  @override
  ConsumerState<NewsActivityReferenceInput> createState() =>
      _NewsActivityReferenceInputState();
}

class _NewsActivityReferenceInputState
    extends ConsumerState<NewsActivityReferenceInput>
    with AfterLayoutMixin<NewsActivityReferenceInput> {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    final initialValue = widget.initialValue;
    if (initialValue != null) {
      ref.read(activityInputProvider.notifier).state = initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = ref.watch(activityInputIsEditingProvider);
    final activity = ref.watch(activityInputProvider);
    final focusNode = ref.watch(activityInputFocusNode);

    final editButton = IconButton(
      onPressed: () {
        ref.read(activityInputIsEditingProvider.notifier).state = true;
      },
      icon: const Icon(
        Icons.edit_outlined,
      ),
      iconSize: 20,
    );

    if (!isEditing) {
      if (activity == null) {
        return Row(
          children: [
            const Text('No activity reference'),
            editButton,
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
              child: NewsActivity(
                activity: activity,
                prefix: 'Activity:',
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.clear_outlined,
              ),
              onPressed: () =>
                  ref.read(activityInputProvider.notifier).state = null,
            ),
          ],
        );
      }
    }

    return FormBuilderTypeAhead<Activity>(
      name: 'activity',
      decoration: const InputDecoration(
        hintText: 'Search activity',
      ),
      focusNode: focusNode,
      textFieldConfiguration: const TextFieldConfiguration(
        autofocus: true,
      ),
      itemBuilder: (context, item) => ListTile(
        leading: CircleAvatar(
          backgroundImage: getBackendImageOrLogoProvider(item.thumbnail),
        ),
        title: Text(item.name!),
      ),
      suggestionsCallback: (pattern) async {
        final organization =
            await ref.read(currentOrganizationServiceProvider.future);
        return ref.read(modActivityRepositoryProvider).getActivities(
              organizationId: organization!.id,
              query: ModActivityQuery(name: pattern),
            );
      },
      selectionToTextTransformer: (suggestion) => suggestion.name!,
      onSuggestionSelected: (suggestion) {
        ref.read(activityInputProvider.notifier).state =
            suggestion.toMinimalActivity();
        ref.read(activityInputIsEditingProvider.notifier).state = false;
      },
    );
  }
}
