import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/auth_service.dart';

final imageInputControllerProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final emailInputControllerProvider = Provider.autoDispose((ref) =>
    TextEditingController(
        text: ref.watch(authServiceProvider).valueOrNull?.account.email));

final usernameFieldControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

final firstNameFieldControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

final lastNameFieldControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

final bioFieldControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

enum Gender {
  male,
  female,
  other,
}

final genderInputSelectionProvider =
    StateProvider.autoDispose<Gender?>((ref) => null);

final dateInputControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

final phoneNumberInputControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());
