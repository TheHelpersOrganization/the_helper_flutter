import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/features/report/domain/report_type.dart';
import 'package:the_helper/src/features/report/presentation/controller/submit_report_screen_controller.dart';

import '../../../../common/widget/file_picker/form_multiple_file_picker_field.dart';
import '../widget/avatar_watcher.dart';

class SubmitReportScreen extends ConsumerWidget {
  final int id;
  final String name;
  final String entityType;
  final int? avatarId;
  final String? subText;

  SubmitReportScreen({
    super.key,
    required this.id,
    required this.name,
    required this.entityType,
    this.avatarId,
    this.subText,
  });

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportType = ref.watch(reportTypeControllerProvider(entityType));
    // ref listen

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Report'),
          centerTitle: true,
        ),
        body: reportType.when(
          error: (error, stacktrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (data) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  // Target info
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: AvatarWatcherWidget(avatarId: avatarId),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              subText != null
                                  ? Text(
                                      subText!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // report type dropdown

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: FormBuilderSearchableDropdown<ReportType>(
                      name: 'reportType',
                      items: data ?? [],
                      itemAsString: (item) => item.name,
                      compareFn: (item1, item2) => item1.id == item2.id,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Report type'),
                        hintText: 'Search and choose report type from list',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      dropdownSearchTextStyle:
                          context.theme.textTheme.bodyLarge,
                    ),
                  ),

                  // report name
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: FormBuilderTextField(
                      name: 'title',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter report\'s title',
                        labelText: 'Title',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(50),
                      ]),
                    ),
                  ),

                  // context
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: FormBuilderTextField(
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
                        hintText: 'What happen?',
                      ),
                    ),
                  ),
                  // file attachment
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: FormMultipleFilePickerField(name: 'files'),
                  ),
                  // button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: PrimaryButton(
                          onPressed: () {
                            context.pop();
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 25)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.error)),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: PrimaryButton(
                          onPressed: () async {
                            _formKey.currentState!.save();
                            var data = _formKey.currentState!.value;

                            await ref
                                .watch(submitReportControllerProvider.notifier)
                                .sendReport(
                                    title: data['title'],
                                    accusedId: id,
                                    entityType: entityType,
                                    reportType: data['reportType'].name,
                                    description: data['description'],
                                    files: data['files']);

                            if (context.mounted) {
                              context.pop();
                            }
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 25)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.primary)),
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
