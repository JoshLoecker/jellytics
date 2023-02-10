import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

bool isDarkMode() {
  // Determine if dark mode
  // From:https://stackoverflow.com/a/56307575
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  return brightness == Brightness.dark;
}

double safeWidth() {
  // Get the width of the safe area and subtract the left/right padding from it
  // The resulting value is the maximum safe width we can make our widgets
  double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  double paddingWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.right *
          2;

  double maxSafeWidth = screenWidth - paddingWidth;

  return maxSafeWidth;
}

Widget loggedInStatusWidget({required bool isLoggedIn, String? username}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      // color: ref.watch(jellyFactory.notifier).state
      color: isLoggedIn ? Colors.green[300] : Colors.red[300],
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      isLoggedIn ? "Logged in as $username" : "Not logged in",
      style: const TextStyle(
        fontSize: 20,
      ),
    ),
  );
}

Widget cupertinoTabBarBuilder() {
  return CupertinoTabBar(
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
  );
}
