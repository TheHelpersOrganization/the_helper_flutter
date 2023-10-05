import 'package:the_helper/src/common/extension/string.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

Iterable<Contact> filterContactsByPattern(
    Iterable<Contact> contacts, String pattern) {
  final lowercasedPattern = pattern.toLowerCase();
  return contacts.where((contact) {
    return contact.name.containsIgnoreCase(lowercasedPattern) ||
        contact.email?.containsIgnoreCase(lowercasedPattern) == true ||
        contact.phoneNumber?.containsIgnoreCase(lowercasedPattern) == true;
  });
}
