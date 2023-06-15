import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_autocomplete.freezed.dart';
part 'place_autocomplete.g.dart';

@freezed
class PlaceAutocomplete with _$PlaceAutocomplete {
  @JsonSerializable(includeIfNull: false)
  factory PlaceAutocomplete({
    required String description,
    required String placeId,
  }) = _PlaceAutocomplete;

  factory PlaceAutocomplete.fromJson(Map<String, dynamic> json) =>
      _$PlaceAutocompleteFromJson(json);
}
