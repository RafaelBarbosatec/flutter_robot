import 'package:flutter_robot_example/src/data/model/location_response.dart';
import 'package:flutter_robot_example/src/infra/adapters/http/http_client.dart';

abstract class IpLocationDatasource {
  Future<LocationResponse> getLocation();
}

class IpLocationDatasourceImpl implements IpLocationDatasource {
  final HttpClient client;

  IpLocationDatasourceImpl({required this.client});

  @override
  Future<LocationResponse> getLocation() {
    return client.get(path: 'json').then((r) {
      return LocationResponse.fromMap(r.body);
    });
  }
}
