class WeatherResponse {
  WeatherResponse({
    required this.location,
    required this.current,
  });
  late final Location location;
  late final Current current;

  WeatherResponse.fromJson(Map<String, dynamic> json) {
    location = Location.fromJson(json['location']);
    current = Current.fromJson(json['current']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['location'] = location.toJson();
    data['current'] = current.toJson();
    return data;
  }
}

class Location {
  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });
  late final String name;
  late final String region;
  late final String country;
  late final double lat;
  late final double lon;
  late final String tzId;
  late final int localtimeEpoch;
  late final String localtime;

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    region = json['region'];
    country = json['country'];
    lat = json['lat'];
    lon = json['lon'];
    tzId = json['tz_id'];
    localtimeEpoch = json['localtime_epoch'];
    localtime = json['localtime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['region'] = region;
    data['country'] = country;
    data['lat'] = lat;
    data['lon'] = lon;
    data['tz_id'] = tzId;
    data['localtime_epoch'] = localtimeEpoch;
    data['localtime'] = localtime;
    return data;
  }
}

class Current {
  Current({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
  });
  late final int lastUpdatedEpoch;
  late final String lastUpdated;
  late final double tempC;
  late final double tempF;
  late final int isDay;
  late final Condition condition;
  late final double windMph;
  late final double windKph;
  late final double windDegree;
  late final String windDir;
  late final double pressureMb;
  late final double pressureIn;
  late final double precipMm;
  late final double precipIn;
  late final double humidity;
  late final double cloud;
  late final double feelslikeC;
  late final double feelslikeF;
  late final double windchillC;
  late final double windchillF;
  late final double heatindexC;
  late final double heatindexF;
  late final double dewpointC;
  late final double dewpointF;
  late final double visKm;
  late final double visMiles;
  late final double uv;
  late final double gustMph;
  late final double gustKph;

  Current.fromJson(Map<String, dynamic> json) {
    lastUpdatedEpoch = json['last_updated_epoch'];
    lastUpdated = json['last_updated'];
    tempC = json['temp_c'].toDouble();
    tempF = json['temp_f'].toDouble();
    isDay = json['is_day'];
    condition = Condition.fromJson(json['condition']);
    windMph = json['wind_mph'].toDouble();
    windKph = json['wind_kph'].toDouble();
    windDegree = json['wind_degree'].toDouble();
    windDir = json['wind_dir'];
    pressureMb = json['pressure_mb'].toDouble();
    pressureIn = json['pressure_in'].toDouble();
    precipMm = json['precip_mm'].toDouble();
    precipIn = json['precip_in'].toDouble();
    humidity = json['humidity'].toDouble();
    cloud = json['cloud'].toDouble();
    feelslikeC = json['feelslike_c'].toDouble();
    feelslikeF = json['feelslike_f'].toDouble();
    windchillC = json['windchill_c'].toDouble();
    windchillF = json['windchill_f'].toDouble();
    heatindexC = json['heatindex_c'].toDouble();
    heatindexF = json['heatindex_f'].toDouble();
    dewpointC = json['dewpoint_c'].toDouble();
    dewpointF = json['dewpoint_f'].toDouble();
    visKm = json['vis_km'].toDouble();
    visMiles = json['vis_miles'].toDouble();
    uv = json['uv'].toDouble();
    gustMph = json['gust_mph'].toDouble();
    gustKph = json['gust_kph'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['last_updated_epoch'] = lastUpdatedEpoch;
    data['last_updated'] = lastUpdated;
    data['temp_c'] = tempC;
    data['temp_f'] = tempF;
    data['is_day'] = isDay;
    data['condition'] = condition.toJson();
    data['wind_mph'] = windMph;
    data['wind_kph'] = windKph;
    data['wind_degree'] = windDegree;
    data['wind_dir'] = windDir;
    data['pressure_mb'] = pressureMb;
    data['pressure_in'] = pressureIn;
    data['precip_mm'] = precipMm;
    data['precip_in'] = precipIn;
    data['humidity'] = humidity;
    data['cloud'] = cloud;
    data['feelslike_c'] = feelslikeC;
    data['feelslike_f'] = feelslikeF;
    data['windchill_c'] = windchillC;
    data['windchill_f'] = windchillF;
    data['heatindex_c'] = heatindexC;
    data['heatindex_f'] = heatindexF;
    data['dewpoint_c'] = dewpointC;
    data['dewpoint_f'] = dewpointF;
    data['vis_km'] = visKm;
    data['vis_miles'] = visMiles;
    data['uv'] = uv;
    data['gust_mph'] = gustMph;
    data['gust_kph'] = gustKph;
    return data;
  }
}

class Condition {
  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });
  late final String text;
  late final String icon;
  late final int code;

  Condition.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    icon = json['icon'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['icon'] = icon;
    data['code'] = code;
    return data;
  }
}
