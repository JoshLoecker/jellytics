import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/utils/storage.dart' as storage;
import 'package:jellytics/providers/serverDetails.dart';

class JellyfinFactory extends AsyncNotifier<JellyfinFactory> {
  Dio dio = Dio();
  bool isLoggedIn = false;
  String username = "";

  static Dio _defaultDio() {
    Dio dio = Dio();
    dio.options.headers = {
      "Content-Type": "application/json",
      "x-emby-authorization":
          "MediaBrowser , Client='Jellytics', Device='Jellytics', DeviceId='script', Version='0.0.1'"
    };
    return dio;
  }

  static Future<Dio> clientFromStorage() async {
    Dio dio = _defaultDio();
    String accessToken = await storage.getAccessToken();
    dio.options.headers["x-emby-authorization"] += ", Token=$accessToken";
    dio.options.baseUrl = await storage.getFinalServerAddress();
    return dio;
  }

  static Future<Dio> getAccessTokenFromUsernamePassword(
      {required String url,
      required String username,
      required String password}) async {
    Dio dio = _defaultDio();
    dio.options.baseUrl = url;

    final result = await dio.post(
      "/Users/AuthenticateByName",
      data: {"Username": username, "Pw": password},
    );

    dio.options.headers["x-emby-authorization"] +=
        ", Token=${result.data["AccessToken"]}";

    await storage.storeAccessToken(result.data["AccessToken"]);
    await storage.storeUserID(result.data["User"]["Id"]);

    return dio;
  }

  static Future<Dio> getAccessTokenFromStorage() async {
    Dio dio = _defaultDio();
    String accessToken = await storage.getAccessToken();
    dio.options.headers["x-emby-authorization"] += ", Token=$accessToken";
    dio.options.baseUrl = await storage.getFinalServerAddress();
    return dio;
  }

  @override
  Future<JellyfinFactory> build() async {
    JellyfinFactory factory = JellyfinFactory();

    String protocol = ref.watch(serverAddressProvider.notifier).protocol;
    String ipAddress = ref.watch(serverAddressProvider.notifier).ipAddress;
    String port = ref.watch(serverAddressProvider.notifier).port;
    username = ref.watch(usernameProvider.notifier).username;
    String password = ref.watch(passwordProvider.notifier).password;
    late Dio internalDio;

    if (await storage.getAccessToken() == "" ||
        await storage.getUserID() == "") {
      internalDio = await JellyfinFactory.getAccessTokenFromUsernamePassword(
        url: "$protocol$ipAddress:$port",
        username: username,
        password: password,
      );
    } else {
      internalDio = await JellyfinFactory.getAccessTokenFromStorage();
    }

    dio.options = internalDio.options;
    dio.httpClientAdapter = internalDio.httpClientAdapter;
    dio.transformer = internalDio.transformer;

    ref.watch(serverAddressProvider.notifier).userId =
        await storage.getUserID();
    isLoggedIn = true;

    return factory;
  }
}

// Extend JellyfinFactory with a new method called "getImages"
extension JellyfinFactoryImages on JellyfinFactory {
  Future<dynamic> getImages(String itemId) async {
    final result = await dio.get("/Items/$itemId/Images/Primary");
    return result.data;
  }
}

final jellyFactory = AsyncNotifierProvider<JellyfinFactory, JellyfinFactory>(
    JellyfinFactory.new);
