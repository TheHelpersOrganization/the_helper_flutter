import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:the_helper/src/common/widget/required_text.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/controller/mod_activity_creation_controller.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/utils/profile.dart';

final _formKey = GlobalKey<FormBuilderState>();

class ActivityContactCreateView extends ConsumerStatefulWidget {
  final List<Contact>? initialContacts;

  const ActivityContactCreateView({
    super.key,
    this.initialContacts,
  });

  @override
  ConsumerState<ActivityContactCreateView> createState() =>
      _ShiftContactViewState();
}

class _ShiftContactViewState extends ConsumerState<ActivityContactCreateView> {
  final phoneController = PhoneController(null);

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(activityManagersProvider);
    final selectedContacts =
        ref.watch(selectedContactsProvider) ?? widget.initialContacts;
    final selectedContactName = ref.watch(selectedContactNameProvider);

    if (members.hasError) {
      ref.invalidate(activityManagersProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        actions: [
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

              ref.read(selectedContactsProvider.notifier).state = [
                ...selectedContacts ?? [],
                Contact(
                  name: name,
                  email: email,
                  phoneNumber: phoneNumber?.international,
                ),
              ];

              context.pop();
            },
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
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
                  selectionToTextTransformer: (suggestion) => suggestion.name,
                  valueTransformer: (value) => value,
                  suggestionsCallback: (pattern) {
                    final data = members.valueOrNull;
                    if (data == null) {
                      return [];
                    }
                    var profiles = data.managers.map((e) => e.profile!);
                    profiles = matchProfiles(profiles, pattern);
                    return profiles
                        .map(
                          (e) => Contact(
                            name: getProfileName(e),
                            email: e.email,
                            phoneNumber: e.phoneNumber,
                          ),
                        )
                        .toList();
                  },
                  onSuggestionSelected: (suggestion) async {
                    _formKey.currentState!.fields['name']!
                        .didChange(suggestion);
                    if (suggestion.email != null) {
                      _formKey.currentState!.fields['email']!
                          .didChange(suggestion.email);
                    }
                    if (suggestion.phoneNumber != null) {
                      phoneController.value =
                          PhoneNumber.parse(suggestion.phoneNumber!);
                    }
                    ref.read(selectedContactNameProvider.notifier).state =
                        suggestion.name;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: RequiredText('Name'),
                    hintText: 'Enter or search the person name',
                    helperText: 'Search by username, email or enter manually',
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
      ),
    );
  }
}
