
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/contact/application/contact_service.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

part 'other_profile_contact_controller.g.dart';

@riverpod
class ProfileContactController extends _$ProfileContactController {
  @override
  FutureOr<List<Contact>> build({required int userId}) async {
    return _getContact(userId);
  }

  Future<List<Contact>> _getContact(int userId) async {
    // final account = ref.watch(authServiceProvider).value!.account;
    final ContactService contactService = ref.watch(contactServiceProvider);
    final List<Contact> orgs = await contactService.getOfAccount(id: userId);
    return orgs;
  }

}
