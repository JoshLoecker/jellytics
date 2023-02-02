/*
This file implements flutter_secure_storage
*/
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum LoginKeys { serverURL, mediaBrowser, token, username, userID }

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  // no options yet;
  IOSOptions _getIOSOptions() => const IOSOptions();
  AndroidOptions _getAndriodOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> addItem({required LoginKeys key, required String value}) async {
    await _storage.write(
      key: key.name.toUpperCase(),
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndriodOptions(),
    );
  }

  Future<String> getItem({required LoginKeys key}) async {
    String? value = await _storage.read(
      key: key.name.toUpperCase(),
      iOptions: _getIOSOptions(),
      aOptions: _getAndriodOptions(),
    );
    if (value == null) {
      return "";
    } else {
      return value;
    }
  }

  Future<bool> isLoginSetup() async {
    /*
        _mediaBrowser = "MediaBrowser "
        "Client=${LoginObject._clientName}, "
        "Device=${LoginObject._deviceName}, "
        "DeviceId=$_deviceID, "
        "Version=${LoginObject._version}";
     */

    bool loginSetup = false;
    for (var value in LoginKeys.values) {
      if (await getItem(key: value) != "") {
        loginSetup = true;
      } else {
        loginSetup = false;
        break;
      }
    }
    return loginSetup;
  }

  Future<void> clear() async {
    if (kDebugMode) {
      print(
        "Num before deleting: ${await _storage.readAll().then((value) => value.length)}",
      );
      await _storage.deleteAll(
        iOptions: _getIOSOptions(),
        aOptions: _getAndriodOptions(),
      );
      print(
        "Num after deleting: ${await _storage.readAll().then((value) => value.length)}",
      );
    }
  }

  Future<void> printStorageItems() async {
    if (kDebugMode) print(await _storage.readAll());
  }

  Future<String> getServerURL() async {
    return await getItem(key: LoginKeys.serverURL);
  }

  Future<String> getMediaBrowser() async {
    return await getItem(key: LoginKeys.mediaBrowser);
  }

  Future<String> getMediaToken() async {
    return await getItem(key: LoginKeys.token);
  }

  Future<String> getUserID() async {
    return await getItem(key: LoginKeys.userID);
  }
}
