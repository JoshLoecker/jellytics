import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellytics/api/authentication.dart';
import 'package:jellytics/api/paths.dart';
import 'package:jellytics/utils/secure_storage.dart';

class _SettingsWidget extends StatefulWidget {
  const _SettingsWidget();

  @override
  State<_SettingsWidget> createState() => _SettingsState();
}

class _SettingsState extends State<_SettingsWidget> {
  String _username = "";
  String _password = "";
  String _serverURL = "";
  final SecureStorage _storage = SecureStorage();
  String _loginError = "";
  late final String _message;

  void getLoginData() async {
    if (_username != "" && _password != "" && _serverURL != "") {
      await LoginObject.construct(
        username: _username,
        password: _password,
        serverURL: _serverURL,
      );

      // Validate user is logged in
      GETSystem systemData = GETSystem();
      if (!await systemData.isLoggedIn()) {
        _message = "Error logging in! "
            "Check that your 'Server URL' starts with "
            "'http://' or 'https://', "
            "and ends in a port number (default http Jellyfin port is 8096).";
      } else {
        _message = "Successfully logged in!";
      }
    } else if (await _storage.getMediaBrowser() != "") {
      _message = "Successfully logged in!";
    }

    setState(() {
      _loginError = _message;
    });
  }

  void clearStorageData() async {
    await _storage.clear();
  }

  void printStorageItems() async {
    await _storage.printStorageItems();
  }

  Future<String> setInitialValue(LoginKeys key) async {
    return await _storage.getItem(key: key);
  }

  Widget debugSecureStorage() {
    /// Show several secure storage buttons if we are in debug mode
    ///
    /// If we are not debugging, simply return empty Text
    if (kDebugMode) {
      return Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: clearStorageData,
            child: const Text("Clear SecureStorage"),
          ),
          ElevatedButton(
            onPressed: printStorageItems,
            child: const Text("Print Storage Items"),
          ),
        ],
      );
    } else {
      return const Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          initialValue: "joshl",
          onChanged: (input) {
            setState(() {
              _username = input;
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Username",
          ),
        ),
        TextFormField(
          initialValue: "cheap-wrist-refined-BUILT-rafter-nutria-tedious-molar",
          obscureText: true,
          onChanged: (input) {
            setState(() {
              _password = input;
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Password",
          ),
        ),
        TextFormField(
          initialValue: "http://192.168.50.61:8096",
          onChanged: (input) {
            setState(() {
              _serverURL = input;
            });
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Server URL: http://192.168.1.20:8096"),
        ),
        ElevatedButton(
          onPressed: getLoginData,
          child: const Text("Log in"),
        ),
        debugSecureStorage(), // Used in debugging, not present in release mode
        Text(
          _loginError,
          softWrap: true,
        ),
      ],
    );
  }
}

const Widget settingsContent = _SettingsWidget();
