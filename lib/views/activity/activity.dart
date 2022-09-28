import 'package:flutter/material.dart';
import 'package:jellytics/utils/extensions.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/views/activity/parse_streams.dart';

class _ActivityWidget extends StatefulWidget {
  const _ActivityWidget();

  @override
  State<_ActivityWidget> createState() => _ActivityState();
}

class _ActivityState extends State<_ActivityWidget> {
  void isLoginAvailable() async {
    /*
    This function tests if the secure storage data contains our username/token/serverURL information
    */
    SecureStorage storage = SecureStorage();
    await storage.isLoginSetup();
  }

  Widget activityCard(
      {required String? titleName,
      required int? seasonNumber,
      required int? episodeNumber,
      required String? episodeTitle,
      required int currentSeconds,
      required int currentMinutes,
      required int totalSeconds,
      required int totalMinutes,
      required String? userPlaying,
      double maxHeight = 125,
      MaterialColor containerColor = Colors.grey}) {
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
                  children: <Widget>[
                    Text(titleName!),
                    Text(
                        // Set up S01 - E05 - EPISODE TITLE
                        "S$seasonNumber - E$episodeNumber - $episodeTitle"),
                    Text(
                      // 10:45 of 23:15
                      "$currentMinutes:${currentSeconds.leadingZero()} of $totalMinutes:${totalSeconds.leadingZero()}",
                    ),
                    Text(userPlaying!),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end, // place at bottom of card
              children: const <Widget>[
                Icon(Icons.play_circle),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget activityListView() {
    return FutureBuilder(
      future: startParse(),
      builder: (context, AsyncSnapshot<List<StreamsData>> streams) {
        if (streams.hasData) {
          //print(streams.data?[0].titleName);
          return ListView.builder(
              itemCount: streams.data?.length,
              itemBuilder: (context, index) {
                return activityCard(
                  titleName: streams.data?[index].masterName,
                  seasonNumber: streams.data?[index].seasonNum,
                  episodeNumber: streams.data?[index].episodeNum,
                  episodeTitle: streams.data?[index].episodeTitle,
                  currentSeconds: 4,
                  currentMinutes: 2,
                  totalSeconds: 9,
                  totalMinutes: 10,
                  userPlaying: streams.data?[index].userName,
                );
              });
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget infiniteListView({int itemCount = 10}) {
    return Scrollbar(
      child: NotificationListener<ScrollNotification>(
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return activityCard(
              titleName: "Friends",
              seasonNumber: 1,
              episodeNumber: 10,
              episodeTitle: "My Episode Title",
              currentSeconds: 09,
              currentMinutes: 2,
              totalSeconds: 4,
              totalMinutes: 09,
              userPlaying: "joshl",
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
    isLoginAvailable();
    // return infiniteListView();
    return activityListView();
  }
}

const Widget activityContent = _ActivityWidget();
