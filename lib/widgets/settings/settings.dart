import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/providers/serverDetails.dart' as server;
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

class SettingsState extends ConsumerState<Settings> {
  @override
  void initState() {
    super.initState();
  }

  String getInitialServerAddress() {
    if (ref.watch(server.serverAddressProvider.notifier).ipAddress == "") {
      return "";
    } else if (ref.watch(server.serverAddressProvider.notifier).port == "") {
      return ref.watch(server.serverAddressProvider.notifier).ipAddress;
    } else {
      return "${ref.watch(server.serverAddressProvider.notifier).ipAddress}:${ref.watch(server.serverAddressProvider.notifier).port}";
    }
  }

  Future<String> getUsername() async {
    return await storage.getUsername();
  }

  bool getLoginColor() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Create a TextField Controller for the server URL input
    final TextEditingController serverUrlController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final JellyfinFactory jellyClient = ref.watch(jellyFactory.notifier);

    // print("STATE: ${ref.watch(jellyFactory.notifier).state.value?.options.headers}");

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
              isLoggedIn: ref.watch(jellyFactory.notifier).isLoggedIn,
              username: jellyClient.username),
          // Drop-down widget with options "http://" and "https://"
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 19),
                child: DropdownButton(
                  value:
                      ref.watch(server.serverAddressProvider.notifier).protocol,
                  items: const [
                    DropdownMenuItem(
                      value: "http://",
                      child: Text("http://"),
                    ),
                    DropdownMenuItem(
                      value: "https://",
                      child: Text("https://"),
                    ),
                  ],
                  onChanged: (changedState) {
                    setState(() {
                      changedState == "http://"
                          ? ref
                              .watch(server.serverAddressProvider.notifier)
                              .protocol = "http://"
                          : ref
                              .watch(server.serverAddressProvider.notifier)
                              .protocol = "https://";
                    });
                  },
                ),
              ),
              // Server URL input
              Flexible(
                child: Focus(
                  onFocusChange: (hasFocus) async {
                    if (!hasFocus) {
                      String ipAddress = serverUrlController.text.split(":")[0];
                      String port = serverUrlController.text.split(":")[1];
                      ref
                          .watch(server.serverAddressProvider.notifier)
                          .ipAddress = ipAddress;
                      ref.watch(server.serverAddressProvider.notifier).port =
                          port;
                      await storage.storeServerIP(ipAddress);
                      await storage.storeServerPort(port);
                    }
                  },
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "192.168.1.10:8096",
                      labelText: "Server URL",
                    ),
                    initialValue: getInitialServerAddress(),
                    onChanged: (String value) {
                      serverUrlController.text = value.toString();
                    },
                  ),
                ),
              ),
            ],
          ),
          // Username input
          Flexible(
            child: Focus(
              onFocusChange: (hasFocus) async {
                if (!hasFocus) {
                  ref.watch(server.usernameProvider.notifier).username =
                      usernameController.text;
                  await storage.storeUsername(
                      ref.watch(server.usernameProvider.notifier).username);
                }
              },
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("Username"),
                ),
                initialValue:
                    ref.watch(server.usernameProvider.notifier).username,
                onChanged: (String value) {
                  usernameController.text = value.toString();
                },
              ),
            ),
          ),
          Flexible(
            child: Focus(
              onFocusChange: (hasFocus) async {
                if (!hasFocus) {
                  ref.watch(server.passwordProvider.notifier).password =
                      passwordController.text;
                }
              },
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("Password"),
                ),
                initialValue:
                    ref.watch(server.passwordProvider.notifier).password,
                obscureText: true,
                // Update text on change
                onChanged: (String value) {
                  passwordController.text = value.toString();
                },
              ),
            ),
          ),
          // A few pixel space between the input fields and the login button
          Container(
            margin: const EdgeInsets.only(top: 20),
          ),
          // Login button
          ElevatedButton(
            onPressed: () async {
              await ref.watch(jellyFactory.notifier).build();
              await ref.read(server.serverAddressProvider.notifier).saveData();
              setState(() {
                ref.watch(jellyFactory.notifier).isLoggedIn = true;
              });
            },
            child: const Text("Login"),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
          ),
          ElevatedButton(
            // Set color of button to red
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              await storage.clearStorage();
              jellyClient.dio.options.headers =
                  await jellyClient.dio.options.headers.remove("Token");

              setState(() {
                ref.watch(jellyFactory.notifier).isLoggedIn = false;
              });
            },
            child: const Text("Logout"),
          ),
          // Show a button if in debug mode
          if (kDebugMode)
            Container(
              margin: const EdgeInsets.only(top: 20),
            ),
          if (kDebugMode)
            ElevatedButton(
              onPressed: () async {
                if (kDebugMode) {
                  print("");
                  print("Headers: ${jellyClient.dio.options.headers}");
                  print("Username: ${await storage.getUsername()}");
                  print("UserID: ${await storage.getUserID()}");
                  print("Protocol: ${await storage.getServerProtocol()}");
                  print("IP: ${await storage.getServerIP()}");
                  print("Port: ${await storage.getServerPort()}");
                  print(
                      "Final Server Address: ${await storage.getFinalServerAddress()}");
                  print("Access Token: ${await storage.getAccessToken()}");
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
