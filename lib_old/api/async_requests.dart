import 'package:dio/dio.dart';
import 'package:jellytics/api/paths.dart';
import 'package:jellytics/utils/secure_storage.dart';

class CreateRequest {
  BaseOptions _options = BaseOptions();
  final Dio _dio = Dio();

  CreateRequest();
  CreateRequest._internal();

  static Future<CreateRequest> construct() async {
    CreateRequest request = CreateRequest._internal();
    SecureStorage storage = SecureStorage();
    await storage.isLoginSetup();

    request._options = BaseOptions(
      baseUrl: await storage.getServerURL(),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-Emby-Authorization": await storage.getMediaBrowser(),
      },
    );
    request._dio.options = request._options;

    return request;
  }

  Future<Response> _makeRequest(
    dynamic path, {
    required RequestType requestType,
    Map<String, String>? payload,
    Map<String, dynamic>? queryParameters,
    BaseOptions? options,
  }) async {
    // If options is null, set it to _options
    // This allows us to pass our own options if we want to
    options ??= _options;
    options.method = requestType.name;
    _dio.options = options;

    return await _dio.request(
      path.path,
      data: payload,
      queryParameters: queryParameters,
    );
  }

  Future<Response> get(
    GET path, {
    Map<String, dynamic>? queryParameters,
    BaseOptions? options,
  }) async {
    return await _makeRequest(
      path,
      requestType: RequestType.get,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    POST path, {
    Map<String, String>? payload,
    BaseOptions? options,
  }) async {
    return await _makeRequest(
      path,
      requestType: RequestType.post,
      payload: payload,
      options: options,
    );
  }
}
