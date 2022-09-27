import 'package:flutter/material.dart';
import 'package:jellytics/api/end_points.dart';
import 'package:jellytics/utils/secure_storage.dart';

class _SettingsWidget extends StatefulWidget {
  const _SettingsWidget();

  @override
  State<_SettingsWidget> createState() => _SettingsState();
}

class _SettingsState extends State<_SettingsWidget> {
  String username = "";
  String password = "";
  String serverURL = "";
  String loginData = "";
  final TextEditingController usernameTextController = TextEditingController();

  void getLoginData() async {
    if (username != "" && password != "" && serverURL != "") {
      LoginObject login = LoginObject(
          username: username, password: password, serverURL: serverURL);

      await login.getMediaToken();

      // Update class variable loginData, use setState so Flutter knows a value changed
      // Flutter will redraw screen as a result
      setState(() {
        loginData = login.mediaBrowser.token;
      });

      print("Starting write...");
      await writeData();
      print("Wrote data!");
      await readData();
      print("Read data!");
    } else {
      print("all values empty");
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
              username = input;
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
              password = input;
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
              serverURL = input;
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
