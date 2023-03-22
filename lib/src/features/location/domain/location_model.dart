import 'dart:convert';

class LocationModel {
  final int? id;
  final String? addressLine1;
  final String? addressLine2;
  final String? locality;
  final String? region;
  final String? country;
  final double? longitude;
  final double? latitude;

  const LocationModel({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.locality,
    this.region,
    this.country,
    this.longitude,
    this.latitude,
  });

  LocationModel copyWith({
    int? id,
    String? addressLine1,
    String? addressLine2,
    String? locality,
    String? region,
    String? country,
    double? longitude,
    double? latitude,
  }) {
    return LocationModel(
      id: id ?? this.id,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      locality: locality ?? this.locality,
      region: region ?? this.region,
      country: country ?? this.country,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'locality': locality,
      'region': region,
      'country': country,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] != null ? map['id'] as int : null,
      addressLine1:
          map['addressLine1'] != null ? map['addressLine1'] as String : null,
      addressLine2:
          map['addressLine2'] != null ? map['addressLine2'] as String : null,
      locality: map['locality'] != null ? map['locality'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LocationModel(id: $id, addressLine1: $addressLine1, addressLine2: $addressLine2, locality: $locality, region: $region, country: $country, longitude: $longitude, latitude: $latitude)';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.addressLine1 == addressLine1 &&
        other.addressLine2 == addressLine2 &&
        other.locality == locality &&
        other.region == region &&
        other.country == country &&
        other.longitude == longitude &&
        other.latitude == latitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        addressLine1.hashCode ^
        addressLine2.hashCode ^
        locality.hashCode ^
        region.hashCode ^
        country.hashCode ^
        longitude.hashCode ^
        latitude.hashCode;
  }

  String get fullAddress {
    return [
      addressLine1,
      addressLine2,
      locality,
      region,
      country,
    ].whereType<String>().toList().join(', ');
  }
}
