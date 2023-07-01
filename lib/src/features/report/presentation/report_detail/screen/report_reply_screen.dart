import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import 'package:the_helper/src/common/widget/button/primary_button.dart';


import '../../../../../common/widget/file_picker/form_multiple_file_picker_field.dart';
import '../controller/reply_report_message_controller.dart';
import '../controller/report_detail_controller.dart';


class ReportReplyScreen extends ConsumerWidget {
  final int id;
  final String title;

  ReportReplyScreen({
    super.key,
    required this.id,
    required this.title,
  });

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: Text(
                  "Re: $title",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // report type dropdown

              // context
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: FormBuilderTextField(
                  name: 'content',
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(2000),
                  ]),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Content'),
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
                            .watch(
                                replyReportMessageControllerProvider.notifier)
                            .sendMessage(
                                id: id,
                                content: data['content'],
                                files: data['files']);

                        if (context.mounted) {
                          ref.invalidate(reportDetailControllerProvider);
                          context.pop();
                        }
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 25)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text('Send'),
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
