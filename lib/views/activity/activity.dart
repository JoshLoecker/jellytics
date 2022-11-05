import 'package:flutter/material.dart';
import 'package:jellytics/data_classes/active_streams.dart';
import 'package:jellytics/views/activity/get_activity.dart';
import 'package:jellytics/views/activity/activity_detail.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/utils/screens.dart';
import 'package:transparent_image/transparent_image.dart';

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

  Widget activityCard({
    required StreamsData streamData,
    double maxCardHeight = 125,
    MaterialColor containerColor = Colors.grey,
  }) {
    // This is the 2nd line, right below the Movie/Series title
    String detailLine = "";
    if (streamData.mediaType == MediaFormat.movie) {
      detailLine = streamData.releaseYear.toString();
    } else if (streamData.mediaType == MediaFormat.episode) {
      detailLine =
          "S${streamData.seasonNum} E${streamData.episodeNum} - ${streamData.episodeTitle}";
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ActivityDetailWidget(streamData: streamData)),
        );
      },
      child: defaultCard(
        context: context,
        maxCardHeight: maxCardHeight,
        containerChild: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Image artwork
            Container(
              alignment: Alignment.center,
              width: 75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(streamData.imagePath),
                  fadeInDuration: const Duration(milliseconds: 200),
                ),
              ),
            ),
            // Text information (playing title, year, user)
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
            // Play icon in lower right
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

  @override
  Widget build(BuildContext context) {
    isLoginAvailable(); // ensure login data is available

    return FutureBuilder(
      future: getActivity(),
      builder: (context, AsyncSnapshot<List<StreamsData>> futures) {
        if (futures.hasData) {
          if (futures.data?.isEmpty == true) {
            return const Text(
              "It's pretty empty around here.\nTry playing something!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            );
          } else {
            return Scrollbar(
              child: ListView.builder(
                itemCount: futures.data?.length,
                itemBuilder: (context, index) {
                  return activityCard(streamData: futures.data![index]);
                },
              ),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

const Widget activityContent = _ActivityWidget();
