import 'package:form_builder_validators/form_builder_validators.dart';

final passwordValidator = FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  FormBuilderValidators.minLength(6),
  FormBuilderValidators.maxLength(100),
]);
