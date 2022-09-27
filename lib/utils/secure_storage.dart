/*
This file implements flutter_secure_storage
*/
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum loginKeys { serverURL, token }

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  // no options yet;
  IOSOptions _getIOSOptions() => const IOSOptions();
  AndroidOptions _getAndriodOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  Future<void> addItem({required loginKeys key, required String value}) async {
    await _storage.write(
      key: key.name.toUpperCase(),
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndriodOptions(),
    );
  }

  Future<String?> getItem({required loginKeys key}) async {
    return await _storage.read(
      key: key.name.toUpperCase(),
      iOptions: _getIOSOptions(),
      aOptions: _getAndriodOptions(),
    );
  }

  Future<bool> isLoginSetup() async {
    bool loginSetup = false;
    for (var value in loginKeys.values) {
      if (await getItem(key: value) != null) {
        loginSetup = true;
      } else {
        loginSetup = false;
      }
    }
    return loginSetup;
  }
}
