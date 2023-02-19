import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/providers/serverDetails.dart';
import 'package:jellytics/utils/storage.dart' as storage;
import 'package:jellytics/utils/interface.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Settings(),
    );
  }
}

class Settings extends ConsumerStatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  ConsumerState<Settings> createState() => SettingsState();
}

class SettingsState extends ConsumerState<Settings> with clientFromStorage {
  final protocolController = TextEditingController();
  final serverUrlController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initClient(ref);
    protocolController.text = "http://";
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text("Protocol"),
        message: const Text("Select a protocol for your server"),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                protocolController.text = "http://";
                ref.read(serverDetailsProvider.notifier).protocol = "http://";
              });
              Navigator.pop(context);
            },
            child: const Text("http://"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                protocolController.text = "https://";
                ref.read(serverDetailsProvider.notifier).protocol = "https://";
              });
              Navigator.pop(context);
            },
            child: const Text("https://"),
          ),
        ],
      ),
    );
  }

  CupertinoTextField usernameTextField() {
    return CupertinoTextField(
      autocorrect: false,
      enableSuggestions: false,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey,
            width: 0.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
      ),
      placeholder: "Username",
      controller: usernameController,
      onChanged: (String value) {
        if (value.isNotEmpty) {
          usernameController.text = value.toString();
          // Place the cursor at the end of the text
          usernameController.selection = TextSelection.fromPosition(
              TextPosition(offset: usernameController.text.length));
        }
      },
    );
  }

  CupertinoTextField passwordTextField() {
    return CupertinoTextField(
      autocorrect: false,
      obscureText: true,
      enableSuggestions: false,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey,
            width: 0.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
      ),
      placeholder: "Password",
      controller: passwordController,
      onChanged: (String value) {
        if (value.isNotEmpty) {
          passwordController.text = value.toString();
          // Place the cursor at the end of the text
          passwordController.selection = TextSelection.fromPosition(
              TextPosition(offset: passwordController.text.length));
        }
      },
    );
  }

  Widget loginButton() {
    return SizedBox(
      width: 185,
      height: 75,
      child: CupertinoButton.filled(
        onPressed: () async {
          bool isLoggedIn = await ref
              .watch(clientDetailsProvider.notifier)
              .clientFromUsernamePassword(
                url:
                    "${protocolController.value.text}${serverUrlController.value.text}",
                username: usernameController.value.text,
                password: passwordController.value.text,
                ref: ref,
              )
              .then((result) {
            result == true
                ? ref.read(serverDetailsProvider.notifier).saveData()
                : {};
            return result;
          });

          if (isLoggedIn) {
            await ref.read(serverDetailsProvider.notifier).saveData();
          }

          setState(() {
            if (isLoggedIn) {
              ref.watch(clientDetailsProvider.notifier).isLoggedIn = true;
              // Set login details
              ref.read(serverDetailsProvider.notifier).protocol =
                  protocolController.value.text;
              ref.read(serverDetailsProvider.notifier).ipAddress =
                  serverUrlController.value.text.split(":")[0];
              ref.read(serverDetailsProvider.notifier).port =
                  serverUrlController.value.text.split(":")[1];
              ref.read(serverDetailsProvider.notifier).fullAddress =
                  "${protocolController.value.text}${serverUrlController.value.text}";
              ref.read(serverDetailsProvider.notifier).username =
                  usernameController.value.text;
            }
          });
        },
        child: const Text("Login"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(clientDetailsProvider.notifier);
    return Container(
      margin: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Login status text
          // If not logged in, make the background have a light-red color
          // If logged in, make the background have a light-green color
          // Add padding on the color around the text
          loggedInStatusWidget(
              isLoggedIn: ref.watch(clientDetailsProvider.notifier).isLoggedIn,
              username: ref.watch(serverDetailsProvider.notifier).username),
          // Drop-down widget with options "http://" and "https://"
          if (!ref.watch(clientDetailsProvider.notifier).isLoggedIn)
            Row(
              children: <Widget>[
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _showActionSheet(context);
                  },
                  child: Text(protocolController.value.text),
                ),
                // Server URL input
                Flexible(
                  child: CupertinoTextField(
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CupertinoColors.systemGrey,
                          width: 0.0, // One physical pixel.
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    placeholder: "192.168.1.10:8096",
                    controller: serverUrlController,
                    onChanged: (String value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          serverUrlController.text = value.toString();
                          // Place the cursor at the end of the text
                          serverUrlController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: serverUrlController.text.length));

                          if (value.contains(":")) {
                            ref.read(serverDetailsProvider.notifier).ipAddress =
                                value.split(":")[0];
                            ref.read(serverDetailsProvider.notifier).port =
                                value.split(":")[1];
                          }
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          if (!ref.watch(clientDetailsProvider.notifier).isLoggedIn)
            Flexible(child: usernameTextField()),
          if (!ref.watch(clientDetailsProvider.notifier).isLoggedIn)
            Flexible(child: passwordTextField()),
          if (!ref.watch(clientDetailsProvider.notifier).isLoggedIn)
            Container(margin: const EdgeInsets.only(top: 20)),
          if (!ref.watch(clientDetailsProvider.notifier).isLoggedIn)
            loginButton(),
          if (!ref.watch(clientDetailsProvider.notifier).isLoggedIn)
            Container(margin: const EdgeInsets.only(top: 20)),
          SizedBox(
            width: 185,
            child: CupertinoButton(
              // Logout button
              color: Colors.red,
              onPressed: () async {
                await storage.clearStorage();

                setState(() {
                  ref.watch(clientDetailsProvider.notifier).logout();
                  ref.watch(serverDetailsProvider.notifier).logout();
                });
              },
              child: const Text("Logout"),
            ),
          ),
          // Show a button if in debug mode
          if (kDebugMode)
            Container(
              margin: const EdgeInsets.only(top: 20),
            ),
          if (kDebugMode)
            CupertinoButton(
              onPressed: () async {
                if (kDebugMode) {
                  print("");
                  print(
                      "Headers: ${ref.read(clientDetailsProvider.notifier).dio.options.headers}");
                  print("Username: ${await storage.getUsername()}");
                  print("UserID: ${await storage.getUserId()}");
                  print("Protocol: ${await storage.getProtocol()}");
                  print("IP: ${await storage.getIP()}");
                  print("Port: ${await storage.getPort()}");
                  print(
                      "Final Server Address: ${await storage.getFinalServerAddress()}");
                  print("Access Token: ${await storage.getAccessToken()}");
                  print(
                      "isLoggedIn: ${ref.read(clientDetailsProvider.notifier).isLoggedIn}");
                  print("");
                }
              },
              child: const Text("Print SecureStorage"),
            ),
          if (kDebugMode)
            Container(
              margin: const EdgeInsets.only(top: 20),
            ),
        ],
      ),
    );
  }
}
