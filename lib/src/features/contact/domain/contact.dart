import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.g.dart';
part 'contact.freezed.dart';

@freezed
class Contact with _$Contact {
  factory Contact({
    required String name,
    String? phoneNumber,
    String? email,
  }) = _Contact;
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
