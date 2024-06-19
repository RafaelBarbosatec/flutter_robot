class WeatherEntity {
  final double tempC;
  final double tempF;
  final WeatherLocationEntity location;
  final WeatherConditionEntity condition;
  final bool isDay;
  final DateTime lastUpdated;

  WeatherEntity({
    required this.tempC,
    required this.tempF,
    required this.location,
    required this.condition,
    required this.isDay,
    required this.lastUpdated,
  });
}

class WeatherLocationEntity {
  final String region;
  final String country;
  final double lat;
  final double lon;

  WeatherLocationEntity({
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });
}

class WeatherConditionEntity {
  final String text;
  final int code;

  WeatherConditionEntity({required this.text, required this.code});

  bool get isCLoudy => code == 1003 || code == 1006 || code == 1009;
}
