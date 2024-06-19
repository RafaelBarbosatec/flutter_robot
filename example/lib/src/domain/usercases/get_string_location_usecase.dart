import 'package:flutter_robot_example/src/data/ip_location_datasource.dart';

abstract class GetStringLocationUsecase {
  Future<String> call();
}

class GetStringLocationUsecaseImpl implements GetStringLocationUsecase {
  final IpLocationDatasource ipLocationDatasource;

  GetStringLocationUsecaseImpl({
    required this.ipLocationDatasource,
  });

  @override
  Future<String> call() async {
    final location = await ipLocationDatasource.getLocation();
    return '${location.city}/${location.region} - ${location.countryCode}';
  }
}
