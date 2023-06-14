import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_autocomplete_query.freezed.dart';
part 'place_autocomplete_query.g.dart';

@freezed
class PlaceAutocompleteQuery with _$PlaceAutocompleteQuery {
  @JsonSerializable(includeIfNull: false)
  factory PlaceAutocompleteQuery({
    required String input,
    String? sessionToken,
  }) = _PlaceAutocompleteQuery;

  factory PlaceAutocompleteQuery.fromJson(Map<String, dynamic> json) =>
      _$PlaceAutocompleteQueryFromJson(json);
}
