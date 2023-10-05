import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/features/organization/presentation/organization_registration/widget/organization_registration_step_complete.dart';
import 'package:the_helper/src/features/organization/presentation/organization_registration/widget/organization_registration_step_file.dart';
import 'package:the_helper/src/features/organization/presentation/organization_registration/widget/organization_registration_step_location.dart';
import 'package:the_helper/src/features/organization/presentation/organization_registration/widget/organization_registration_step_one.dart';
import 'package:the_helper/src/features/organization/presentation/organization_registration/widget/organization_registration_step_two.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/step.dart';

import '../../../../location/domain/location.dart';
import '../controller/organization_registration_controller.dart';

class OrganizationRegistrationScreen extends ConsumerWidget {
  OrganizationRegistrationScreen({super.key});

  final _formKeys = [
    organizationRegistrationStepOneFormKey,
    organizationRegistrationStepTwoFormKey,
    organizationRegistrationStepLocationFormKey,
    organizationRegistrationStepFileFormKey,
  ];

  final steps = [
    const StepView(
      title: Text('Basic Info'),
      content: OrganizationRegistrationStepOne(),
    ),
    const StepView(
      title: Text('Logo'),
      content: OrganizationRegistrationStepTwo(),
    ),
    const StepView(
      title: Text('Location'),
      content: OrganizationRegistrationStepLocation(),
    ),
    const StepView(
      title: Text('Related Files'),
      content: OrganizationRegistrationStepFile(),
    ),
    const StepView(
      title: Text('Complete'),
      content: OrganizationRegistrationStepComplete(),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentStep = ref.watch(currentStepProvider);
    final res = ref.watch(createOrganizationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoute.home.name),
        ),
        title: const Text('Register Organization'),
        centerTitle: true,
      ),
      body: res.when(
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
        error: (error, stackTrace) {
          print(stackTrace);
          return Text('Error: $error');
        },
        data: (data) {
          if (data == null) {
            return Stepper(
              steps: createSteps(steps: steps, currentStep: currentStep),
              currentStep: currentStep,
              type: StepperType.horizontal,
              onStepContinue: () {
                String? phoneNumber =
                    _formKeys[0].currentState?.value['phoneNumber'];
                if (phoneNumber?.startsWith('+') != true) {
                  phoneNumber = '+84$phoneNumber';
                }
                print(phoneNumber);
                final isLastPage = currentStep == steps.length - 1;
                if (!isLastPage) {
                  if (!_formKeys[currentStep].currentState!.saveAndValidate()) {
                    return;
                  }
                }
                if (isLastPage) {
                  var basicInfo = _formKeys[0].currentState!.value;
                  final logo = _formKeys[1].currentState!.value['logo'];
                  final banner = _formKeys[1].currentState!.value['banner'];
                  final country = _formKeys[2].currentState!.value['country'];
                  final String countryCode;
                  if (country is Country) {
                    countryCode = country.countryCode;
                  } else {
                    countryCode = Country.parse(country).countryCode;
                  }
                  final locations = [
                    Location.fromJson({
                      ..._formKeys[2].currentState!.value,
                      'country': countryCode,
                    }),
                  ];
                  final files = _formKeys[3].currentState!.value['files'];
                  String phoneNumber = basicInfo['phoneNumber'];
                  if (!phoneNumber.startsWith('+')) {
                    phoneNumber = '+84$phoneNumber';
                  }
                  ref
                      .read(createOrganizationControllerProvider.notifier)
                      .createOrganization(
                          name: basicInfo['name'],
                          email: basicInfo['email'],
                          phoneNumber: phoneNumber,
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
      ),
    );
  }
}
