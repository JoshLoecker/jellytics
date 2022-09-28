import 'package:flutter/material.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/views/activity/get_activity.dart';

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
      {required StreamsData streamData,
      double maxHeight = 125,
      MaterialColor containerColor = Colors.grey}) {
    // Get the width of the safe area and subtract the left/right padding from it
    // The resulting value is the maximum safe width we can make our widgets
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingWidth = MediaQuery.of(context).padding.right * 2;
    double maxSafeWidth = screenWidth - paddingWidth;

    // This is the 2nd line, right below the Movie/Series title
    String detailLine = "";
    if (streamData.mediaType == MediaFormat.movie) {
      detailLine = streamData.releaseYear.toString();
    } else if (streamData.mediaType == MediaFormat.episode) {
      detailLine =
          "S${streamData.seasonNum} E${streamData.episodeNum} - ${streamData.episodeTitle}";
    }

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
              child: Image.network(streamData.imagePath),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  // Place contents at top-right corner, with small padding amount (padding defined above)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(streamData.masterName),
                    Text(detailLine),
                    Text(streamData.userName),
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
      future: getActivity(),
      builder: (context, AsyncSnapshot<List<StreamsData>> streams) {
        if (streams.hasData) {
          if (streams.data?.isEmpty == true) {
            return const Text(
              "It's pretty empty around here.\nTry playing something!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            );
          } else {
            return ListView.builder(
                itemCount: streams.data?.length,
                itemBuilder: (context, index) {
                  return activityCard(streamData: streams.data![index]);
                });
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    isLoginAvailable();
    return activityListView();
  }
}

const Widget activityContent = _ActivityWidget();
