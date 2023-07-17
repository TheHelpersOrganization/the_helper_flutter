import 'package:country_picker/country_picker.dart';
import 'package:the_helper/src/features/location/domain/location.dart';

String getAddress(Location? location, {int? componentCount}) {
  final String address;

  if (location == null) {
    address = 'Unknown';
  } else {
    final Country? country =
        location.country == null ? null : Country.parse(location.country!);
    final components = [
      location.addressLine1,
      location.addressLine2,
      location.locality,
      location.region,
      country?.name,
    ].whereType<String>().toList();
    String fullAddress = '';
    if (componentCount == null || componentCount >= components.length) {
      fullAddress = components.join(', ');
    } else {
      fullAddress =
          components.sublist(components.length - componentCount).join(', ');
    }
    address = fullAddress.isNotEmpty ? fullAddress : 'Unknown';
  }
  return address;
}

String getShortAddress(Location? location) {
  if (location != null) {
    if (location.country != null) {
      return location.country!;
    }
    if (location.region != null) {
      return location.region!;
    }
    if (location.locality != null) {
      return location.locality!;
    }
    if (location.addressLine1 != null) {
      return location.addressLine1!;
    }
  }
  return 'Unknown';
}

String? toCountryNameOrNull(String? countryIsoCode) {
  if (countryIsoCode == null) {
    return null;
  }
  final country = Country.tryParse(countryIsoCode);
  return country?.name;
}
