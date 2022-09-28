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

  void getLoginData() async {
    if (_username != "" && _password != "" && _serverURL != "") {
      await LoginObject.construct(
        username: _username,
        password: _password,
        serverURL: _serverURL,
      );

      // Validate user is logged in
      final String message;
      GETSystem systemData = GETSystem();
      if (!await systemData.isLoggedIn()) {
        message = "Error logging in! "
            "Check that your 'Server URL' starts with "
            "'http://' or 'https://', "
            "and ends in a port number (default http Jellyfin port is 8096).";
      } else {
        message = "Successfully logged in!";
      }
      setState(() {
        _loginError = message;
      });

      // Add the token to secure storage to be able to read from it later
      _storage.addItem(key: LoginKeys.serverURL, value: _serverURL);
      //_storage.addItem(key: LoginKeys.mediaBrowser, value: login.mediaBrowser);
      //_storage.addItem(key: LoginKeys.mediaToken, value: login.mediaToken);
      //_storage.addItem(key: LoginKeys.userID, value: login.userID);
    }
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
        ElevatedButton(
          onPressed: clearStorageData,
          child: const Text("Clear SecureStorage"),
        ),
        ElevatedButton(
            onPressed: printStorageItems,
            child: const Text("Print Storage Items")),
        Text(
          _loginError,
          softWrap: true,
        ),
      ],
    );
  }
}

const Widget settingsContent = _SettingsWidget();
