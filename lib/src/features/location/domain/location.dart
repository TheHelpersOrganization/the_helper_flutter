import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/extension/string.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location with _$Location {
  factory Location({
    int? id,
    String? addressLine1,
    String? addressLine2,
    String? locality,
    String? region,
    String? country,
    double? latitude,
    double? longitude,
  }) = _Location;
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

extension LocationX on Location {
  String get formattedAddress {
    final address = StringBuffer();
    if (addressLine1 != null) {
      address.write(addressLine1);
    }
    if (addressLine2 != null) {
      if (address.isNotEmpty) {
        address.write(', ');
      }
      address.write(addressLine2);
    }
    if (locality != null) {
      if (address.isNotEmpty) {
        address.write(', ');
      }
      address.write(locality);
    }
    if (region != null) {
      if (address.isNotEmpty) {
        address.write(', ');
      }
      address.write(region);
    }
    if (country != null) {
      if (address.isNotEmpty) {
        address.write(', ');
      }
      address.write(country);
    }
    return address.toString();
  }

  bool contains(Location other) {
    if (country != null) {
      final c = country!
          .toLowerCase()
          .replaceAll(RegExp('[^A-Za-z0-9]'), '')
          .withoutDiacriticalMarks;
      final o = other.country
          ?.toLowerCase()
          .replaceAll(RegExp('[^A-Za-z0-9]'), '')
          .withoutDiacriticalMarks;
      if (c != o) {
        return false;
      }
    }
    if (region != null) {
      final r = region!
          .toLowerCase()
          .replaceAll(RegExp('[^A-Za-z0-9]'), '')
          .withoutDiacriticalMarks;
      final o = other.region
          ?.toLowerCase()
          .replaceAll(RegExp('[^A-Za-z0-9]'), '')
          .withoutDiacriticalMarks;
      if (r != o) {
        return false;
      }
    }
    if (locality != null) {
      final l = locality!
          .toLowerCase()
          .replaceAll(RegExp('[^A-Za-z0-9]'), '')
          .withoutDiacriticalMarks;
      final o = other.locality
          ?.toLowerCase()
          .replaceAll(RegExp('[^A-Za-z0-9]'), '')
          .withoutDiacriticalMarks;
      if (l != o) {
        return false;
      }
    }
    if (addressLine1 != null) {
      final a =
          addressLine1!.toLowerCase().replaceAll(RegExp('[^A-Za-z0-9]'), '');
      final o = other.addressLine1
          ?.toLowerCase()
          .replaceAll(RegExp('[^A-Za-z0-9]'), '');
      if (a != o) {
        print('addressLine1: $a != $o');
        return false;
      }
    }
    if (addressLine2 != null) {
      final a =
          addressLine2!.toLowerCase().replaceAll(RegExp('[^A-Za-z0-9]'), '');
      final o = other.addressLine2
          ?.toLowerCase()
          .replaceAll(RegExp('[^A-Za-z0-9]'), '');
      if (a != o) {
        return false;
      }
    }
    return true;
  }
}
