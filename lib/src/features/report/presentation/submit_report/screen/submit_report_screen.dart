import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/features/report/presentation/submit_report/controller/submit_report_screen_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

import '../../../../../common/widget/file_picker/form_multiple_file_picker_field.dart';
import '../../widget/avatar_watcher.dart';

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
    // ref listen
    ref.listen<AsyncValue>(
      submitReportControllerProvider,
      (e, state) {
        state.showSnackbarOnError(context);
        if (state.value != null) {
          state.showSnackbarOnSuccess(
            context,
            content: const Text('Report send!'),
          );
        }
      },
    );

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
      body: SingleChildScrollView(
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
                                  style: Theme.of(context).textTheme.labelLarge,
                                )
                              : const SizedBox()
                        ],
                      ),
                    )
                  ],
                ),
              ),

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
                  name: 'content',
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(2000),
                  ]),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Content'),
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
                        // _formKey.currentState!.save();
                        if (!_formKey.currentState!.saveAndValidate()) {
                          return;
                        }
                        var data = _formKey.currentState!.value;

                        await ref
                            .watch(submitReportControllerProvider.notifier)
                            .sendReport(
                                title: data['title'],
                                id: id,
                                type: entityType,
                                content: data['content'],
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
    );
  }
}
