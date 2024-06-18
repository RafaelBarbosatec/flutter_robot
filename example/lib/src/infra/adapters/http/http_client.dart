abstract class HttpClient {
  final String baseUrl;

  HttpClient({required this.baseUrl});
  Future<HttpResponse> get({
    required String path,
    Map<String, dynamic>? queryParams,
  });
}

class HttpResponse {
  final int? code;
  final Map<String, dynamic> body;

  HttpResponse({
    required this.code,
    required this.body,
  });
}
