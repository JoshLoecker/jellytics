import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jellytics/views/views.dart' as views;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove(); // App is built, OK to remove splash screen
    return const MaterialApp(
      title: "Jellytics",
      home: StatefulApp(),
    );
  }
}

class StatefulApp extends StatefulWidget {
  const StatefulApp({super.key});

  @override
  State<StatefulApp> createState() => _StatefulApp();
}

class _StatefulApp extends State<StatefulApp> {
  int _currentNavIndex = 0;
  final String _appBarTitle = "Jellytics";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: Center(
        child: _screenWidgets.elementAt(_currentNavIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: _currentNavIndex,
        selectedItemColor: const Color(0xff0066ff),
        onTap: _onNavBarTapped,
      ),
    );
  }

  // This is a list of items that are being provided as the "content" widgets.
  // Modifying content of these files will impact the view on the appropriate screen widget
  static const List<Widget> _screenWidgets = <Widget>[
    views.activityContent,
    views.libraryContent,
    views.settingsContent,
  ];

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
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const App());
}
