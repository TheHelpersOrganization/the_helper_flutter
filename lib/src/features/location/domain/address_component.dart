import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_component.freezed.dart';
part 'address_component.g.dart';

@freezed
class AddressComponent with _$AddressComponent {
  @JsonSerializable(includeIfNull: false)
  factory AddressComponent({
    required String longName,
    required String shortName,
    required List<String> types,
  }) = _AddressComponent;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentFromJson(json);
}
