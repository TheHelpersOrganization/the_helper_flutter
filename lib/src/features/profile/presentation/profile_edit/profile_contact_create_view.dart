import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_contact_controller.dart';

final _formKey = GlobalKey<FormBuilderState>();

class ProfileContactCreateView extends ConsumerStatefulWidget {
  const ProfileContactCreateView({
    super.key,
  });

  @override
  ConsumerState<ProfileContactCreateView> createState() =>
      _ProfileContactCreateViewState();
}

class _ProfileContactCreateViewState
    extends ConsumerState<ProfileContactCreateView> {
  void showErrorDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: false,
        builder: (dialogContext) => SimpleDialog(
              alignment: Alignment.center,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              children: [
                Center(
                  child: Text(
                    'Something went wrong',
                    style: TextStyle(
                      color: dialogContext.theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                FilledButton(
                  onPressed: () {
                    dialogContext.pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            ));
  }

  final phoneController = PhoneController(null);
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              if (!_formKey.currentState!.saveAndValidate()) {
                return;
              }
              final formData = _formKey.currentState!.value;

              // Typeahead do not give new value after manually editing the text field
              // Use provider instead
              final name = formData['name']!;
              final email = formData['email'];
              final phoneNumber = phoneController.value;

              // ref.read(selectedContactsProvider.notifier).state = [
              //   ...selectedContacts ?? [],
              //   Contact(
              //     name: name,
              //     email: email,
              //     phoneNumber: phoneNumber?.international,
              //   ),
              // ];

              final res = await ref
                  .read(profileContactControllerProvider.notifier)
                  .addContact(
                    Contact(
                      name: name,
                      email: email,
                      phoneNumber: phoneNumber?.international,
                    ),
                  );
              if (context.mounted) {
                if (res == null) {
                  showErrorDialog();
                }
                context.pop();
              }

              ref.invalidate(profileContactControllerProvider);
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
                FormBuilderTextField(
                  name: 'name',
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Name'),
                    hintText: 'Enter name',
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
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.email(),
                  ]),
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
