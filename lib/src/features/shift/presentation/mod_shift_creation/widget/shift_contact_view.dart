import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/required_text.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';

final _formKey = GlobalKey<FormBuilderState>();

class ShiftContactView extends ConsumerStatefulWidget {
  final List<int>? initialContacts;

  const ShiftContactView({
    super.key,
    this.initialContacts,
  });

  @override
  ConsumerState<ShiftContactView> createState() => _ShiftContactViewState();
}

class _ShiftContactViewState extends ConsumerState<ShiftContactView> {
  final phoneController = PhoneController(null);

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersState = ref.watch(memberDataProvider);
    final selectedContactIds =
        ref.watch(selectedContactIdsProvider) ?? widget.initialContacts;
    final selectedContactName = ref.watch(selectedContactNameProvider);

    if (membersState.hasError) {
      ref.invalidate(memberDataProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        actions: membersState.valueOrNull == null
            ? null
            : [
                TextButton.icon(
                  onPressed: () {
                    if (!_formKey.currentState!.saveAndValidate()) {
                      return;
                    }
                    final formData = _formKey.currentState!.value;

                    // Typeahead do not give new value after manually editing the text field
                    // Use provider instead
                    final name = selectedContactName!;
                    final email = formData['email'];
                    final phoneNumber = phoneController.value;

                    // ref.read(selectedContactIdsProvider.notifier).state = [
                    //   ...selectedContactIds ?? [],
                    //   Contact(
                    //     name: name,
                    //     email: email,
                    //     phoneNumber: phoneNumber?.international,
                    //   ),
                    // ];

                    context.pop();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Save'),
                ),
              ],
      ),
      body: membersState.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => CustomErrorWidget(
          onRetry: () => ref.invalidate(memberDataProvider),
        ),
        data: (data) {
          final availableContacts =
              data.managers.flatMap((e) => e.contacts!).toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTypeAhead<Contact>(
                      textFieldConfiguration: TextFieldConfiguration(
                        onChanged: (value) {
                          ref.read(selectedContactNameProvider.notifier).state =
                              value;
                        },
                      ),
                      name: 'name',
                      itemBuilder: (context, itemData) {
                        return ListTile(
                          title: Text(itemData.name),
                          subtitle: Text(
                            itemData.email ?? itemData.phoneNumber ?? '',
                          ),
                        );
                      },
                      selectionToTextTransformer: (suggestion) =>
                          suggestion.name,
                      valueTransformer: (value) => value,
                      suggestionsCallback: (pattern) {
                        return availableContacts.filterByPattern(pattern);
                      },
                      onSuggestionSelected: (suggestion) async {
                        // _formKey.currentState!.fields['name']!
                        //     .didChange(suggestion);
                        // if (suggestion.email != null) {
                        //   _formKey.currentState!.fields['email']!
                        //       .didChange(suggestion.email);
                        // }
                        // if (suggestion.phoneNumber != null) {
                        //   phoneController.value =
                        //       PhoneNumber.parse(suggestion.phoneNumber!);
                        // }
                        // ref.read(selectedContactNameProvider.notifier).state =
                        //     suggestion.name;
                        // ref.read(selectedC)
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: RequiredText('Name'),
                        hintText: 'Enter or search the person name',
                        helperText:
                            'Search by username, email or enter manually',
                        helperMaxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PhoneFormField(
                      controller: phoneController,
                      defaultCountry: IsoCode.VN,
                      isCountryChipPersistent: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Phone number'),
                        hintText: 'Enter phone number',
                      ),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'email',
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Email'),
                        hintText: 'Enter email',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
