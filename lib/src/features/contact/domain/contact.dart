import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/extension/string.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
class Contact with _$Contact {
  factory Contact({
    int? id,
    int? accountId,
    required String name,
    String? phoneNumber,
    String? email,
  }) = _Contact;
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}

extension IterableContactX on Iterable<Contact> {
  Iterable<Contact> filterByPattern(String pattern) {
    final lowercasedPattern = pattern.toLowerCase();
    return where((contact) {
      return contact.name.containsIgnoreCase(lowercasedPattern) ||
          contact.email?.containsIgnoreCase(lowercasedPattern) == true ||
          contact.phoneNumber?.containsIgnoreCase(lowercasedPattern) == true;
    });
  }
}
