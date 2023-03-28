import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/country_picker.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/common/widget/file_picker/form_multiple_file_picker_field.dart';
import 'package:the_helper/src/common/widget/image_picker/form_custom_image_picker.dart';
import 'package:the_helper/src/common/widget/phone_number_field.dart';
import 'package:the_helper/src/common/widget/required_text.dart';
import 'package:the_helper/src/features/organization/presentation/registration/organization_registration_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/config_provider.dart';

import '../../../location/domain/location.dart';

class OrganizationRegistrationScreen extends ConsumerStatefulWidget {
  const OrganizationRegistrationScreen({super.key});

  @override
  ConsumerState<OrganizationRegistrationScreen> createState() =>
      _OrganizationRegistrationScreenState();
}

class _OrganizationRegistrationScreenState
    extends ConsumerState<OrganizationRegistrationScreen> {
  final _formKeys = [
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
  ];

  Step _buildStep0(
    GlobalKey<FormBuilderState> key,
    int index,
    int currentStep,
  ) {
    return Step(
      title: currentStep == index ? const Text('Basic Info') : const Text(''),
      state: currentStep > index ? StepState.complete : StepState.indexed,
      isActive: currentStep >= index,
      content: SingleChildScrollView(
        //padding: const EdgeInsets.symmetric(horizontal: 24),
        child: FormBuilder(
          key: _formKeys[0],
          child: Column(
              children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g Volunteer-organization_0',
                label: RequiredText('Name'),
                helperText: 'Can contain letter, number, spaces, - and _',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.match(
                  RegExp(r'^[\w,.0-9\s-]+$').pattern,
                  errorText:
                      'Can only contain letters, numbers, spaces, - and _',
                ),
              ]),
            ),
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g name@organization.com',
                label: RequiredText('Email'),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            PhoneNumberField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g 0 123 456 7890',
                label: RequiredText('Phone Number'),
              ),
              validator: FormBuilderValidators.required(),
            ),
            FormBuilderTextField(
              name: 'website',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g www.your-organization.com',
                label: RequiredText('Website'),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.url(),
              ]),
            ),
            FormBuilderTextField(
              name: 'description',
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: null,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(200),
              ]),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: RequiredText('Description'),
                hintText: 'Write about what your organization does',
              ),
            ),
            const SizedBox(height: 16),
            if (AppConfig.debug)
              Column(
                children: [
                  FilledButton.icon(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () {
                      final fields = _formKeys[index].currentState!.fields;
                      fields['name']!.didChange('Test');
                      fields['email']!.didChange('test@org.com');
                      fields['phoneNumber']!.didChange('+84339049688');
                      fields['website']!.didChange('www.test.com');
                      fields['description']!.didChange('Test description');
                    },
                    label: const Text('Fill Test Data'),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
          ].padding(
            const EdgeInsets.symmetric(vertical: 12),
            ignoreFirst: true,
            ignoreLast: true,
          )),
        ),
      ),
    );
  }

  Step _buildStep1(
    GlobalKey<FormBuilderState> key,
    int index,
    int currentStep,
  ) {
    String? logoUrl = ref.watch(logoUrlProvider);
    String? bannerUrl = ref.watch(bannerUrlProvider);

    ImageProvider? logoImage;
    if (logoUrl != null) {
      if (kIsWeb) {
        logoImage = NetworkImage(logoUrl);
      } else {
        logoImage = Image.file(File(logoUrl)).image;
      }
    }

    ImageProvider? bannerImage;
    if (bannerUrl != null) {
      if (kIsWeb) {
        bannerImage = NetworkImage(bannerUrl);
      } else {
        bannerImage = Image.file(File(bannerUrl)).image;
      }
    }

    return Step(
      title: Text(currentStep == index ? 'Logo' : ''),
      state: currentStep > index ? StepState.complete : StepState.indexed,
      isActive: currentStep >= index,
      content: SingleChildScrollView(
        child: FormBuilder(
          key: _formKeys[1],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Banner',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FormCustomImagePickerField(
                name: 'banner',
                image: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: bannerImage == null
                      ? SizedBox(
                          width: context.mediaQuery.size.width * 0.8,
                          height: 128,
                        )
                      : Image(
                          image: bannerImage,
                          width: context.mediaQuery.size.width * 0.8,
                          height: 128,
                          fit: BoxFit.cover,
                        ),
                ),
                onImagePicked: (file) =>
                    ref.read(bannerUrlProvider.notifier).state = file.path,
                shape: const RoundedRectangleBorder(),
                pickerPadding: EdgeInsets.symmetric(
                  vertical: 64 - 12,
                  horizontal: context.mediaQuery.size.width * 0.4 - 12,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              const Divider(),
              RequiredText(
                'Logo',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FormCustomImagePickerField(
                name: 'logo',
                image: CircleAvatar(
                  radius: context.mediaQuery.size.width * 0.15,
                  backgroundImage: logoImage,
                  backgroundColor: Colors.grey.withAlpha(10),
                ),
                onImagePicked: (file) =>
                    ref.read(logoUrlProvider.notifier).state = file.path,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(
                height: 64,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Step _buildStep2(
    GlobalKey<FormBuilderState> key,
    int index,
    int currentStep,
  ) {
    return Step(
      title: Text(currentStep == index ? 'Location' : ''),
      state: currentStep > index ? StepState.complete : StepState.indexed,
      isActive: currentStep >= index,
      content: FormBuilder(
        key: key,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'addressLine1',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g 268 Ly Thuong Kiet Street, Ward 14',
                label: Text('Address Line'),
                helperText: 'Street No, Street Name, Ward',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            FormBuilderTextField(
              name: 'locality',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g District 10',
                label: Text('District / City'),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            FormBuilderTextField(
              name: 'region',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g Ho Chi Minh City',
                label: RequiredText('City / Province'),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            FormFieldCountryPicker(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Pick a country',
                label: RequiredText('Country'),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            const SizedBox(
              height: 32,
            ),
            if (AppConfig.debug)
              Column(
                children: [
                  FilledButton.icon(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () {
                      final fields = _formKeys[index].currentState!.fields;
                      fields['addressLine1']!
                          .didChange('268 Ly Thuong Kiet Street, Ward 14');
                      fields['locality']!.didChange('District 10');
                      fields['region']!.didChange('Ho Chi Minh City');
                    },
                    label: const Text('Fill Test Data'),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
          ].padding(
            const EdgeInsets.symmetric(vertical: 16),
            ignoreFirst: true,
            ignoreLast: true,
          ),
        ),
      ),
    );
  }

  Step _buildStep3(
    GlobalKey<FormBuilderState> key,
    int index,
    int currentStep,
  ) {
    return Step(
      title: Text(currentStep == index ? 'Related Files' : ''),
      state: currentStep > index ? StepState.complete : StepState.indexed,
      isActive: currentStep >= index,
      content: FormBuilder(
        key: key,
        child: Column(
          children: [
            FormMultipleFilePickerField(name: 'files'),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  Step _buildStep4(
    GlobalKey<FormBuilderState> key,
    int index,
    int currentStep,
  ) {
    return Step(
      title: Text(currentStep == index ? 'Complete' : ''),
      state: currentStep > index ? StepState.complete : StepState.indexed,
      isActive: currentStep >= index,
      content: Column(
        children: [
          const Text(
              'You may want to review your information before submitting.'),
          Text.rich(
            TextSpan(
              text: 'After review, please click ',
              children: [
                TextSpan(
                  text: 'Submit',
                  style: TextStyle(
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' to finish the registration.'),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentStep = ref.watch(currentStepProvider);
    final res = ref.watch(createOrganizationControllerProvider);

    // return Scaffold(
    //   body: Center(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text(
    //             'Organization registration successfully',
    //             style: context.theme.textTheme.titleLarge?.copyWith(
    //               fontWeight: FontWeight.bold,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //           const SizedBox(
    //             height: 16,
    //           ),
    //           PrimaryButton(
    //             onPressed: () {
    //               context.goNamed(AppRoute.home.name);
    //             },
    //             child: const Text('Back to Home'),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed(AppRoute.home.name);
          },
        ),
        title: const Text('Register Organization'),
        centerTitle: true,
      ),
      body: res.when(
        data: (data) {
          if (data == null) {
            // Easier to debug
            List<Step> steps = (<
                    Step Function(GlobalKey<FormBuilderState> key, int index,
                        int currentStep)>[
              _buildStep0,
              _buildStep1,
              _buildStep2,
              _buildStep3,
              _buildStep4,
            ])
                .asMap()
                .map((i, e) => MapEntry(
                    i,
                    e.call(
                      _formKeys[i],
                      i,
                      currentStep,
                    )))
                .values
                .toList();

            return Stepper(
              steps: steps,
              currentStep: currentStep,
              type: StepperType.horizontal,
              onStepContinue: () {
                final isLastPage = currentStep == steps.length - 1;
                if (!isLastPage) {
                  _formKeys[currentStep].currentState?.save();
                  if (!_formKeys[currentStep].currentState!.validate()) {
                    return;
                  }
                }
                if (isLastPage) {
                  var basicInfo = _formKeys[0].currentState!.value;
                  final logo = _formKeys[1].currentState!.value['logo'];
                  final banner = _formKeys[1].currentState!.value['banner'];
                  final locations = [
                    Location.fromJson({
                      ..._formKeys[2].currentState!.value,
                      'country': _formKeys[2]
                          .currentState!
                          .value['country']
                          .countryCode,
                    }),
                  ];
                  final files = _formKeys[3].currentState!.value['files'];

                  ref
                      .read(createOrganizationControllerProvider.notifier)
                      .createOrganization(
                          name: basicInfo['name'],
                          email: basicInfo['email'],
                          phoneNumber: basicInfo['phoneNumber'],
                          description: basicInfo['description'],
                          website: basicInfo['website'],
                          logo: logo,
                          banner: banner,
                          locations: locations,
                          files: files,
                          contacts: []);
                } else {
                  ref.read(currentStepProvider.notifier).state =
                      currentStep + 1;
                }
              },
              onStepCancel: () {
                final isFirstPage = currentStep == 0;
                if (isFirstPage) {
                } else {
                  ref.read(currentStepProvider.notifier).state =
                      currentStep - 1;
                }
              },
              controlsBuilder: (context, details) {
                final isLastPage = currentStep == steps.length - 1;

                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        child: details.currentStep == 0
                            ? const Text('Cancel')
                            : const Text('Back'),
                        onPressed: () {
                          details.onStepCancel?.call();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        onPressed: () {
                          details.onStepContinue?.call();
                        },
                        child: isLastPage
                            ? const Text('Submit')
                            : const Text('Next'),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Organization registration successfully',
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    PrimaryButton(
                      onPressed: () {
                        context.goNamed(AppRoute.home.name);
                      },
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 32,
              ),
              Text(
                'Please wait while we create your organization',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text('This may take a few minutes...'),
            ],
          ),
        ),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
    );
  }
}
