import "package:dio/dio.dart";
import "package:jellytics/api/base_paths.dart";
import 'package:jellytics/api/end_points.dart';

class CreateRequest {
  late final String _baseUrl;
  late final BaseOptions _options;
  late final Dio _dio;
  late final RequestType _method;

  CreateRequest({
    required String baseUrl,
    required RequestType method,
    required MediaBrowser mediaToken,
  }) {
    _baseUrl = baseUrl;
    _method = method;
    _options = BaseOptions(
        baseUrl: _baseUrl,
        method: _method.name.toUpperCase(),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "X-Emby-Authorization": mediaToken.token
        });
    _dio = Dio(_options);
  }

  Future<Response> _makeRequest(dynamic path,
      {Map<String, String>? payload,
      Map<String, dynamic>? queryParameters}) async {
    Response response = await _dio.request(path.path,
        data: payload, queryParameters: queryParameters);
    return response;
  }

  Future<Response> get(GET path,
      {Map<String, dynamic>? queryParameters}) async {
    return await _makeRequest(path, queryParameters: queryParameters);
  }

  Future<Response> post(POST path, {Map<String, String>? payload}) async {
    return await _makeRequest(path, payload: payload);
  }
}
