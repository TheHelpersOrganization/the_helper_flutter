import 'package:the_helper/src/features/location/domain/location.dart';

String getAddress(Location? location) {
  final String address;
  if (location == null) {
    address = 'Unknown';
  } else {
    final fullAddress = [
      location.locality,
      location.region,
      location.country,
    ].whereType<String>().join(', ');
    address = fullAddress.isNotEmpty ? fullAddress : 'Unknown';
  }
  return address;
}
