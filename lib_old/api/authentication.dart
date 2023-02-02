/*
This file is responsible for logging into the Jellyfin server
It will save the following data to flutter_secure_storage:
- Server URL
- Server Access Token
- Media Browser Token
- User ID

From here, these values can be read from flutter_secure_storage.
The media browser token (which includes the access token at the end of its string) can be used
  to implement additional endpoints.
*/

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jellytics/api/async_requests.dart';
import 'package:jellytics/api/paths.dart';
import 'package:jellytics/utils/secure_storage.dart';

class LoginObject {
  static const String _deviceID = "64e3dbe4-1138-11ed-861d-0242ac120002";
  static const String _version = "0.0.1";
  static const String _deviceName = "Lasko";
  static const String _clientName = "Jellytics";

  /// Internal constructor
  LoginObject._internal();

  /// This function will log the user into the Jellyfin server using async requests
  ///
  /// Public constructor
  /// From: https://stackoverflow.com/a/59304510
  ///
  /// It does not return anything. Data is stored in flutter_secure_storage
  static Future<void> construct({
    required String username,
    required String password,
    required String serverURL,
  }) async {
    // Define variables used in this function
    late Response<dynamic> response;
    final SecureStorage storage = SecureStorage();
    late final String token;
    late final String userID;

    // Create a media browser to get the access token later
    String mediaBrowser = "MediaBrowser "
        "Client=${LoginObject._clientName}, "
        "Device=${LoginObject._deviceName}, "
        "DeviceId=${LoginObject._deviceID}, "
        "Version=${LoginObject._version}";

    // Define options for the request
    BaseOptions options = BaseOptions(
      baseUrl: serverURL,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-Emby-Authorization": mediaBrowser,
      },
    );

    // Create and send the request to log in with username/password
    response = await CreateRequest().post(
      POSTUser.authenticateByName,
      payload: {"Username": username, "Pw": password},
      options: options,
    );

    // Retrieve the token and userID, then update the mediaBrowser information
    token = await response.data["AccessToken"];
    userID = await response.data["User"]["Id"];
    mediaBrowser += ", Token=$token";

    // Save data to flutter_secure_storage
    await storage.addItem(key: LoginKeys.serverURL, value: serverURL);
    await storage.addItem(key: LoginKeys.username, value: username);
    await storage.addItem(key: LoginKeys.mediaBrowser, value: mediaBrowser);
    await storage.addItem(key: LoginKeys.token, value: token);
    await storage.addItem(key: LoginKeys.userID, value: userID);
  }
}
