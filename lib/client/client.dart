/// This class is used to store the client details, such as the access token, user ID, etc.
/// It also contains the clientFromStorage() function, which is used to get the client details from storage.

// Freezed
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jellytics/providers/server_details.dart';

// Riverpod
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Additional imports
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:jellytics/utils/storage.dart' as storage;

part 'client.freezed.dart';
part 'client.g.dart';

@freezed
class ClientData with _$ClientData {
  factory ClientData({
    required Dio dio,
    required bool isLoggedIn,
    required String username,
    required String userId,
  }) = _ClientData;
}

@riverpod
class ClientDetails extends _$ClientDetails {
  Dio dio = Dio(_getDefaultOptions());
  String get userId => state.userId;
  bool get isLoggedIn => state.isLoggedIn;

  set isLoggedIn(bool isLoggedIn_) {
    state = state.copyWith(isLoggedIn: isLoggedIn_);
  }

  static BaseOptions _getDefaultOptions() {
    return BaseOptions(
      headers: {
        "Content-Type": "application/json",
        "x-emby-authorization":
            "MediaBrowser , Client='Jellytics', Device='Jellytics', DeviceId='script', Version='0.0.1'"
      },
    );
  }

  @override
  ClientData build() {
    return ClientData(
      dio: dio,
      isLoggedIn: false,
      username: "",
      userId: "",
    );
  }

  Future<void> clientFromStorage() async {
    String protocol = await storage.getProtocol();
    String ipAddress = await storage.getIP();
    String port = await storage.getPort();
    String accessToken = await storage.getAccessToken();
    String username = await storage.getUsername();
    String userId = await storage.getUserId();

    // If the IP address and port are not empty, set the server details
    if (ipAddress != "" && port != "") {
      ref.read(serverDetailsProvider.notifier).protocol = protocol;
      ref.read(serverDetailsProvider.notifier).ipAddress = ipAddress;
      ref.read(serverDetailsProvider.notifier).port = port;
      ref.read(serverDetailsProvider.notifier).fullAddress =
          "$protocol$ipAddress:$port";
    }

    // If the username is not empty, set it
    if (username != "") {
      ref.read(serverDetailsProvider.notifier).username = username;
    }

    // If the user ID is not empty, set it
    if (userId != "") {
      ref.read(serverDetailsProvider.notifier).userId = userId;
    }

    // If the access token is not empty, set it
    if (accessToken != "") {
      ref.read(serverDetailsProvider.notifier).accessToken = accessToken;

      Dio newDio = state.dio;
      newDio.options.headers["x-emby-authorization"] += ", Token=$accessToken";
      state = state.copyWith(
        dio: newDio,
        isLoggedIn: true,
        username: await storage.getUsername(),
        userId: await storage.getUserId(),
      );
    }
  }

  Future<bool> clientFromUsernamePassword({
    required String url,
    required String username,
    required String password,
    required WidgetRef ref,
  }) async {
    Dio internalDio = Dio(_getDefaultOptions());
    internalDio.options.baseUrl = url;

    final result = await internalDio.post(
      "/Users/AuthenticateByName",
      data: {"Username": username, "Pw": password},
    );

    await storage.storeAccessToken(result.data["AccessToken"]);
    await storage.storeUserId(result.data["User"]["Id"]);
    await storage.storeUsername(username);

    internalDio.options.headers["x-emby-authorization"] +=
        ", Token=${result.data["AccessToken"]}";
    ref.watch(serverDetailsProvider.notifier).accessToken =
        result.data["AccessToken"];
    ref.watch(serverDetailsProvider.notifier).userId =
        result.data["User"]["Id"];

    ref.watch(clientDetailsProvider.notifier).dio = internalDio;
    state = state.copyWith(
      dio: internalDio,
      isLoggedIn: true,
      username: username,
      userId: ref.watch(serverDetailsProvider.notifier).userId,
    );

    if (result.data["AccessToken"] != null) {
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    state = state.copyWith(
      dio: Dio(_getDefaultOptions()),
      isLoggedIn: false,
      username: "",
      userId: "",
    );
  }
}

mixin clientFromStorage {
  void initClient(WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(clientDetailsProvider.notifier).clientFromStorage();
    });
  }
}
