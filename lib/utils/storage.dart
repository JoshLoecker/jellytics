import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

class _Keys {
  static String username = "username";
  static String userId = "userId";
  static String protocol = "protocol";
  static String ipAddress = "ipAddress";
  static String port = "port";
  static String accessToken = "accessToken";
}

Future<void> _storeData(String key, String value) async {
  await _storage.write(key: key, value: value);
}

Future<String?> _getData(String key) async {
  return await _storage.read(key: key);
}

Future<void> clearStorage() async {
  await _storage.delete(key: _Keys.username);
  await _storage.delete(key: _Keys.userId);
  await _storage.delete(key: _Keys.protocol);
  await _storage.delete(key: _Keys.ipAddress);
  await _storage.delete(key: _Keys.port);
  await _storage.delete(key: _Keys.accessToken);
}

Future<void> storeUsername(String username) async {
  await _storeData(_Keys.username, username);
}

Future<void> storeUserId(String id) async {
  await _storeData(_Keys.userId, id);
}

Future<void> storeServerProtocol(String protocol) async {
  await _storeData(_Keys.protocol, protocol);
}

Future<void> storeServerIP(String serverUrl) async {
  await _storeData(_Keys.ipAddress, serverUrl);
}

Future<void> storeServerPort(String port) async {
  await _storeData(_Keys.port, port);
}

Future<void> storeAccessToken(String accessToken) async {
  await _storeData(_Keys.accessToken, accessToken);
}

Future<String> getUsername() async {
  return await _getData(_Keys.username) ?? "";
}

Future<String> getUserId() async {
  return await _getData(_Keys.userId) ?? "";
}

Future<String> getProtocol() async {
  String token = await _getData(_Keys.protocol) ?? "";
  return token == '' ? 'http://' : token;
}

Future<String> getIP() async {
  return await _getData(_Keys.ipAddress) ?? "";
}

Future<String> getPort() async {
  return await _getData(_Keys.port) ?? "";
}

Future<String> getFinalServerAddress() async {
  final String serverProtocol = await getProtocol();
  final String serverUrl = await getIP();
  final String serverPort = await getPort();
  return "$serverProtocol$serverUrl:$serverPort";
}

Future<String> getAccessToken() async {
  return await _getData(_Keys.accessToken) ?? "";
}
