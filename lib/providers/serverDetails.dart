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

class _Username extends Notifier<String> {
  String username = "";

  @override
  String build() {
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

class _AccessToken extends Notifier<String> {
  String accessToken = "";

  @override
  String build() {
    return accessToken;
  }
}

final serverAddressProvider =
    AsyncNotifierProvider<_ServerAddress, String>(_ServerAddress.new);
final usernameProvider = NotifierProvider<_Username, String>(_Username.new);
final passwordProvider = NotifierProvider<_Password, String>(_Password.new);
final accessTokenProvider =
    NotifierProvider<_AccessToken, String>(_AccessToken.new);
