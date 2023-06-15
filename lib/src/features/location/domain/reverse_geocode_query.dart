import 'package:freezed_annotation/freezed_annotation.dart';

part 'reverse_geocode_query.freezed.dart';
part 'reverse_geocode_query.g.dart';

@freezed
class ReverseGeocodeQuery with _$ReverseGeocodeQuery {
  @JsonSerializable(includeIfNull: false)
  factory ReverseGeocodeQuery({
    required double latitude,
    required double longitude,
  }) = _ReverseGeocodeQuery;

  factory ReverseGeocodeQuery.fromJson(Map<String, dynamic> json) =>
      _$ReverseGeocodeQueryFromJson(json);
}
