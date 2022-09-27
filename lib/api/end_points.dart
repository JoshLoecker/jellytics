import "dart:async";

import "package:dio/dio.dart";
import 'package:jellytics/api/async_requests.dart';
import "package:jellytics/api/base_paths.dart";
import 'package:jellytics/api/paths.dart';

class MediaBrowser {
  late String token;
  MediaBrowser({required String mediaBrowserToken}) {
    token = mediaBrowserToken;
  }
}

class LoginObject {
  late final String _username;
  late final String _password;
  late final String _serverURL;
  late final String _deviceID;
  static const String _version = "0.0.1";
  static const String _deviceName = "Lasko";
  static const String _clientName = "Jellytics";
  late CreateRequest _createRequest;
  late MediaBrowser _mediaBrowser;

  // Getters
  MediaBrowser get mediaBrowser => _mediaBrowser;

  String get serverURL => _serverURL;

  // Constructor
  LoginObject(
      {required String username,
      required String password,
      required String serverURL}) {
    _username = username;
    _password = password;
    _serverURL = serverURL;
    _deviceID = "64e3dbe4-1138-11ed-861d-0242ac120002";

    _mediaBrowser = MediaBrowser(
        mediaBrowserToken:
            "MediaBrowser Client=${LoginObject._clientName}, Device=${LoginObject._deviceName}, DeviceId=$_deviceID, Version=${LoginObject._version}");
    _createRequest = CreateRequest(
        baseUrl: _serverURL,
        method: RequestType.post,
        mediaToken: mediaBrowser);
  }

  Future<void> getMediaToken() async {
    Response request =
        await _createRequest.post(POSTUser.authenticateByName, payload: {
      "Username": _username,
      "Pw": _password,
    });

    // Update the mediaToken with the new token
    _mediaBrowser.token += ", Token=${request.data["AccessToken"]}";
  }
}
