// ignore_for_file: public_member_api_docs, sort_constructors_first

class LocationResponse {
  final String country;
  final String countryCode;
  final String region;
  final String regionName;
  final String city;
  final double lat;
  final double lon;

  LocationResponse({
    required this.country,
    required this.countryCode,
    required this.region,
    required this.regionName,
    required this.city,
    required this.lat,
    required this.lon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'countryCode': countryCode,
      'region': region,
      'regionName': regionName,
      'city': city,
      'lat': lat,
      'lon': lon,
    };
  }

  factory LocationResponse.fromMap(Map<String, dynamic> map) {
    return LocationResponse(
      country: map['country'] as String,
      countryCode: map['countryCode'] as String,
      region: map['region'] as String,
      regionName: map['regionName'] as String,
      city: map['city'] as String,
      lat: map['lat'] as double,
      lon: map['lon'] as double,
    );
  }
}
