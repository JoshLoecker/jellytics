import 'package:flutter/material.dart';
import 'package:jellytics/api/end_points.dart';
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

  void getLoginData() async {
    if (_username != "" && _password != "" && _serverURL != "") {
      LoginObject login = LoginObject(
          username: _username, password: _password, serverURL: _serverURL);

      await login.getMediaToken();

      // Add the token to secure storage to be able to read from it later
      _storage.addItem(key: loginKeys.token, value: login.mediaBrowser.token);
      _storage.addItem(key: loginKeys.serverURL, value: _serverURL);
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
      ],
    );
  }
}

const Widget settingsContent = _SettingsWidget();
