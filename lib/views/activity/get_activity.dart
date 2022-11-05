import 'package:jellytics/api/paths.dart';
import 'package:jellytics/data_classes/active_streams.dart';

Future<List<StreamsData>> getActivity() async {
  /// This function will build a list of StreamsData instances
  ///
  /// It will be used to display data on the "Activity" Page
  GETSession session = GETSession();
  List<dynamic> activeStreams = await session.getActiveStreams();
  List<StreamsData> nowPlayingStreams = <StreamsData>[];

  for (int i = 0; i < activeStreams.length; i++) {
    Map<String, dynamic> currentStream = await activeStreams[i];
    // Find streams that are playing media
    // We will add these to the nowPlayingStreams
    if (await currentStream["NowPlayingItem"] != null) {
      MediaFormat mediaType = getMediaFormat(currentStream);
      String id = (mediaType == MediaFormat.movie)
          ? await currentStream["NowPlayingItem"]["Id"]
          : await currentStream["NowPlayingItem"]["SeriesId"];

      StreamsData data = StreamsData(
        episodeTitle: await currentStream["NowPlayingItem"]["Name"],
        releaseYear: await currentStream["NowPlayingItem"]["ProductionYear"],
        remoteURL: await currentStream["RemoteEndPoint"],
        mediaType: mediaType,
        userName: await currentStream["UserName"],
        seasonNum: await getSeasonNum(currentStream), // -1 if not a series
        episodeNum: await getEpisodeNum(currentStream), // -1 if not a series
        id: id,
        imagePath: await GETImage.itemImageURL(id: id),
        masterName: await currentStream["NowPlayingItem"]["SeriesName"] ??
            await currentStream["NowPlayingItem"]["Name"],
      );

      nowPlayingStreams.add(data);
    }
  }
  return nowPlayingStreams;
}

Future<int> getSeasonNum(Map<String, dynamic> stream) async {
  /// This function gets the integer from "Season ##"
  ///
  /// Example: "Season 1" is in `stream`, then int(1) is returned
  ///          "Season 10" is in `stream`, then int(10) is returned
  String? seasonName = await stream["NowPlayingItem"]["SeasonName"];

  // Working with something other than an episode
  if (seasonName == null) {
    return -1;
  } else {
    // Using a episode number
    seasonName = seasonName.split(" ").last;
    return int.parse(seasonName);
  }
}

Future<int> getEpisodeNum(Map<String, dynamic> stream) async {
  /// This function gets the integer from "Episode ##"
  ///
  /// Example: "Episode 1" is in `stream`, then int(1) is returned
  ///          "Episode 10" is in `stream`, then int(10) is returned
  int? episodeNum = await stream["NowPlayingItem"]["IndexNumber"];

  // Not working with an episode
  if (episodeNum == null) {
    return -1;
  } else {
    // Using an episode number
    return episodeNum;
  }
}

MediaFormat getMediaFormat(Map<String, dynamic> stream) {
  /// This function matches the current media type string with a value in MediaType
  ///
  /// If no MediaType is found, MediaType.unknown is returned
  for (int i = 0; i < MediaFormat.values.length; i++) {
    // Define current MeidaType tag and the current stream's tag
    String currentMediaTag = MediaFormat.values[i].name.toLowerCase();
    String currentStreamTag =
        stream["NowPlayingItem"]["Type"].toString().toLowerCase();

    // If the tags match, return the current tag
    if (currentMediaTag == currentStreamTag) {
      return MediaFormat.values[i];
    }
  }

  // No tag was found, return unknown
  return MediaFormat.unknown;
}
