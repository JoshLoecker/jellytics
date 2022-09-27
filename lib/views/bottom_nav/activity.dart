import "dart:math";

import 'package:flutter/material.dart';

class _ActivityWidget extends StatefulWidget {
  const _ActivityWidget();

  @override
  State<_ActivityWidget> createState() => _ActivityState();
}

class _ActivityState extends State<_ActivityWidget> {
  Widget activityCard(
      {required String label,
      double maxHeight = 125,
      MaterialColor? containerColor}) {
    // Get the width of the safe area and subtract the left/right padding from it
    // The resulting value is the maximum safe width we can make our widgets
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingWidth = MediaQuery.of(context).padding.right * 2;
    double maxSafeWidth = screenWidth - paddingWidth;

    return ConstrainedBox(
      constraints: BoxConstraints.expand(
        width: maxSafeWidth,
        height: maxHeight,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const Image(
                image: AssetImage("assets/f_splash_crop.png"),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  // Place contents at top-right corner, with small padding amount (padding defined above)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    Text("Series Name"),
                    Text("S01 - E10 - Episode Title"),
                    Text("min:sec of min:sec"),
                    Text("User"),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment:
                  MainAxisAlignment.end, // place at bottom of card
              children: const <Widget>[
                Icon(Icons.play_circle),
              ],
            )
          ],
        ),
      ),
    );
  }

  MaterialColor randomColor() {
    // Choose a random primary color; from: https://stackoverflow.com/a/57034842
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  String randomString({int len = 200}) {
    // Create a random string; from: https://stackoverflow.com/a/61929967
    var r = Random();
    String randomString =
        String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
    return randomString;
  }

  Widget infiniteListView({int itemCount = 10}) {
    return Scrollbar(
      child: NotificationListener<ScrollNotification>(
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return activityCard(
              label: randomString(),
              containerColor: Colors.grey,
            );
          }, // itemBuilder
        ),
        onNotification: (notification) {
          // todo: how to use notifications.depth? Use this to rewrite the AppBar title
          return false; // must return false to allow additional notifications to arrive; from: https://stackoverflow.com/a/65653695
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return infiniteListView();
  }
}

const Widget activityContent = _ActivityWidget();
