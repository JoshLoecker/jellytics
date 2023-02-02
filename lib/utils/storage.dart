import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

Future<void> _storeData(String key, String value) async {
  await _storage.write(key: key, value: value);
}

Future<String?> _getData(String key) async {
  return await _storage.read(key: key);
}

Future<void> clearStorage() async {
  await _storage.delete(key: "username");
  await _storage.delete(key: "userID");
  await _storage.delete(key: "accessToken");
}

Future<void> storeUsername(String username) async {
  await _storeData("username", username);
}

Future<void> storeUserID(String id) async {
  await _storeData("userID", id);
}

Future<void> storeServerProtocol(String protocol) async {
  await _storeData("serverHttp", protocol);
}

Future<void> storeServerIP(String serverUrl) async {
  await _storeData("serverIP", serverUrl);
}

Future<void> storeServerPort(String port) async {
  await _storeData("serverPort", port);
}

Future<void> storeAccessToken(String accessToken) async {
  await _storeData("accessToken", accessToken);
}

Future<String> getUsername() async {
  return await _getData("username") ?? "";
}

Future<String> getUserID() async {
  return await _getData("userID") ?? "";
}

Future<String> getServerProtocol() async {
  return await _getData("serverHttp") ?? "";
}

Future<String> getServerIP() async {
  return await _getData("serverIP") ?? "";
}

Future<String> getServerPort() async {
  return await _getData("serverPort") ?? "";
}

Future<String> getFinalServerAddress() async {
  final String serverProtocol = await getServerProtocol();
  final String serverUrl = await getServerIP();
  final String serverPort = await getServerPort();
  return "$serverProtocol$serverUrl:$serverPort";
}

Future<String> getAccessToken() async {
  return await _getData("accessToken") ?? "";
}
