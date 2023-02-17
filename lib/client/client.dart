// Freezed
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jellytics/providers/serverDetails.dart';

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

    if (ipAddress != "" && port != "") {
      ref.read(serverDetailsProvider.notifier).protocol = protocol;
      ref.read(serverDetailsProvider.notifier).ipAddress = ipAddress;
      ref.read(serverDetailsProvider.notifier).port = port;
      ref.read(serverDetailsProvider.notifier).fullAddress =
          "$protocol$ipAddress:$port";
    }
    if (username != "") {
      ref.read(serverDetailsProvider.notifier).username = username;
      ref.read(serverDetailsProvider.notifier).userId =
          await storage.getUserId();
    }

    if (!state.dio.options.headers["x-emby-authorization"]
        .toString()
        .contains(accessToken)) {
      Dio newDio = state.dio;
      newDio.options.headers["x-emby-authorization"] += ", Token=$accessToken";
      state = state.copyWith(
        dio: newDio,
        isLoggedIn: true,
        username: username,
        userId: await storage.getUserId(),
      );
    }
  }

  Future<void> clientFromUsernamePassword({
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
