import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:jellytics/utils/storage.dart' as storage;

class _ServerAddress extends AsyncNotifier<String> {
  String protocol = "http://";
  String ipAddress = "";
  String port = "";
  String userId = "";
  String fullAddress = "";

  @override
  Future<String> build() async {
    // Test if storage.getServerProtocol() is empty. If it is empty, set it to "http://"
    protocol = await storage.getServerProtocol() == ""
        ? "http://"
        : await storage.getServerProtocol();
    ipAddress =
        await storage.getServerIP() == "" ? "" : await storage.getServerIP();
    port = await storage.getServerPort() == ""
        ? ""
        : await storage.getServerPort();
    fullAddress =
        "${ref.watch(serverAddressProvider.notifier).protocol}${ref.watch(serverAddressProvider.notifier).ipAddress}:${ref.watch(serverAddressProvider.notifier).port}";
    return "$protocol$ipAddress:$port";
  }

  Future<void> saveData() async {
    await storage.storeServerIP(ipAddress);
    await storage.storeServerPort(port);
    await storage.storeServerProtocol(protocol);
    await storage.storeUserID(userId);
  }

  String getAddress() {
    if (ref.watch(serverAddressProvider.notifier).port == "") {
      return "${ref.watch(serverAddressProvider.notifier).protocol}${ref.watch(serverAddressProvider.notifier).ipAddress}";
    } else {
      return "${ref.watch(serverAddressProvider.notifier).protocol}${ref.watch(serverAddressProvider.notifier).ipAddress}:${ref.watch(serverAddressProvider.notifier).port}";
    }
  }
}

class _Username extends AsyncNotifier<String> {
  String username = "";

  @override
  Future<String> build() async {
    username = await storage.getUsername();
    return username;
  }
}

class _Password extends Notifier<String> {
  String password = "";

  @override
  String build() {
    return password;
  }
}

class _AccessToken extends AsyncNotifier<String> {
  String accessToken = "";

  @override
  Future<String> build() async {
    accessToken = await storage.getAccessToken();
    return accessToken;
  }
}

final serverAddressProvider =
    AsyncNotifierProvider<_ServerAddress, String>(_ServerAddress.new);
final usernameProvider =
    AsyncNotifierProvider<_Username, String>(_Username.new);
final passwordProvider = NotifierProvider<_Password, String>(_Password.new);
final accessTokenProvider =
    AsyncNotifierProvider<_AccessToken, String>(_AccessToken.new);
