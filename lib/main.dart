import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/widgets/settings/settings.dart';
import 'package:jellytics/widgets/library/library.dart';
import 'package:jellytics/utils/storage.dart' as storage;
import 'package:jellytics/providers/serverDetails.dart' as server_details;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // return const CupertinoApp(
      title: "Jellytics",
      theme: ThemeData(brightness: Brightness.light), // light mode
      darkTheme: ThemeData(brightness: Brightness.dark), // dark mode
      themeMode: ThemeMode.system, // follow system theme
      debugShowCheckedModeBanner: false,
      home: const StatefulApp(),
    );
  }
}

class StatefulApp extends ConsumerStatefulWidget {
  const StatefulApp({super.key});

  @override
  ConsumerState<StatefulApp> createState() => _StatefulApp();
}

class _StatefulApp extends ConsumerState<StatefulApp> {
  int _currentNavIndex = 0;
  final String _appBarTitle = "Jellytics";

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      FlutterNativeSplash.remove(); // App is built, OK to remove splash screen
    }
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
    ref.watch(jellyFactory.notifier);

    // set the server details from storage
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        elevation: 0,
      ),
      body: Center(
        child: _screenWidgets.elementAt(_currentNavIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0, // no drop shadow
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_outlined),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage_outlined),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: "Statistics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
        currentIndex: _currentNavIndex,
        selectedItemColor: const Color(0xff0066ff),
        onTap: _onNavBarTapped,
      ),
    );
  }

  // When tapping on the BottomNavBar, switch to the appropriate index
  void _onNavBarTapped(int index) {
    setState(() {
      _currentNavIndex = index;
    });
  }
}

void main() {
  // Keep splash screen until I say it is cleared
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Check if the platform is not web
  if (!kIsWeb) {
    // If it is not web, then we need to initialize the storage
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );

  // runApp(const ProviderScope(child: App()));
}
