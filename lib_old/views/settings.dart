import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellytics/api/authentication.dart';
import 'package:jellytics/api/paths.dart';
import 'package:jellytics/utils/secure_storage.dart';

class _SettingsWidget extends StatefulWidget {
  const _SettingsWidget({Key? key}) : super(key: key);

  @override
  State<_SettingsWidget> createState() => _SettingsState();
}

class _SettingsState extends State<_SettingsWidget> {
  static const List<String> _validProtocol = <String>['http://', 'https://'];
  String _protocol = "http://";
  String _username = "";
  // late final String port;
  String _password = "";
  String _serverURL = "";
  final SecureStorage _storage = SecureStorage();
  String _loginMessage = "";
  String _message = "";

  void getLoginData() async {
    late final String message;
    if (_username != "" && _password != "" && _serverURL != "") {
      final String loginURL = _protocol + _serverURL;
      await LoginObject.construct(
        username: _username,
        password: _password,
        serverURL: loginURL,
      );

      // Validate user is logged in
      GETSystem systemData = GETSystem();
      if (!await systemData.isLoggedIn()) {
        message = "Error logging in! "
            "Check that your 'Server URL' starts with "
            "'http://' or 'https://', "
            "and ends in a port number (default http Jellyfin port is 8096).";
      } else {
        message = "Successfully logged in!";
      }
    } else if (await _storage.getMediaBrowser() != "") {
      message = "Successfully logged in!";
    } else {
      message = "username is $_username\n"
          "password is $_password\n"
          "serverURL is $_serverURL";
    }

    setState(() {
      _loginMessage = message;
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

  void updateMessage() {
    setState(() {
      _message = "username is $_username\n"
          "password is $_password\n"
          "serverURL is $_serverURL";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Username
        TextFormField(
          initialValue: "joshl",
          autocorrect: false,
          enableSuggestions: false,
          onFieldSubmitted: (input) {
            setState(() {
              _username = input;
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Username",
          ),
        ),
        // Password
        TextFormField(
          initialValue: "",
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
        // Server URL
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
              alignment: Alignment.centerRight,
              value: _protocol,
              items: _validProtocol.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _protocol = value!;
                });
              },
            ),
            Expanded(
              child: TextFormField(
                initialValue: "192.168.50.61:8096",
                onChanged: (input) {
                  setState(() {
                    _serverURL = input;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "192.168.1.20:8096",
                ),
              ),
            ),
          ],
        ),
        // Login Button
        ElevatedButton(
          onPressed: getLoginData,
          child: const Text("Log in"),
        ),
        debugSecureStorage(), // Used in debugging, not present in release mode
        Text(
          _loginMessage,
          softWrap: true,
        ),
      ],
    );
  }
}

const Widget settingsContent = _SettingsWidget();
