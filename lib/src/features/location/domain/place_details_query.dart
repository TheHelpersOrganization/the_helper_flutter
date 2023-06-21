import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_details_query.freezed.dart';
part 'place_details_query.g.dart';

@freezed
class PlaceDetailsQuery with _$PlaceDetailsQuery {
  @JsonSerializable(includeIfNull: false)
  factory PlaceDetailsQuery({
    required String placeId,
    String? sessionToken,
  }) = _PlaceDetailsQuery;

  factory PlaceDetailsQuery.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailsQueryFromJson(json);
}
