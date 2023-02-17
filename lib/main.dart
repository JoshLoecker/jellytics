import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/providers/serverDetails.dart';
import 'package:jellytics/widgets/settings/settings.dart';
import 'package:jellytics/widgets/library/library.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: "Jellytics",
      theme: CupertinoThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _StatefulApp();
}

class _StatefulApp extends ConsumerState<HomePage> {
  final String _appBarTitle = "Jellytics";

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) FlutterNativeSplash.remove();
  }

  // This is a list of items that are being provided as the "content" widgets.
  // Modifying content of these files will impact the view on the appropriate screen widget
  static const List<Widget> _screenWidgets = <Widget>[
    Text("Activity"),
    Library(),
    Text("Statistics"),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    // Load the jellyfin client provider
    ref.watch(clientDetailsProvider.notifier);
    ref.watch(serverDetailsProvider.notifier);

    // set the server details from storage
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_sharp),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage_outlined),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Statistics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(_appBarTitle),
              ),
              child: Center(
                child: _screenWidgets.elementAt(index),
              ),
            );
          },
        );
      },
    );
  }
}

void main() {
  // Keep splash screen until I say it is cleared
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
