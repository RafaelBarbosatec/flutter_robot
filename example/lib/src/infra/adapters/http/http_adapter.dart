import 'package:dio/dio.dart';
import 'package:flutter_robot_example/src/infra/adapters/http/http_client.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpAdapter extends HttpClient {
  late Dio _dio;

  HttpAdapter({
    required super.baseUrl,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        queryParameters: queryParams,
      ),
    );
    _dio.interceptors.add(PrettyDioLogger());
  }
  @override
  Future<HttpResponse> get({
    required String path,
    Map<String, dynamic>? queryParams,
  }) {
    return _dio.get(path, queryParameters: queryParams).then(
          (resp) => HttpResponse(
            code: resp.statusCode,
            body: resp.data,
          ),
        );
  }
}
