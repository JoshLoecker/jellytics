import 'package:jellytics/api/paths.dart';
import 'package:jellytics/api/print.dart';

enum MediaType { movie, episode, unknown }

class StreamsData {
  late final String masterName;
  // late final int completionPercentage; // Not everything shows completion percentage under NowPlayingItem. Not sure why.
  late final int seasonNum;
  late final int episodeNum;
  late final String episodeTitle;
  late final int releaseYear;
  late final MediaType mediaType;
  late final String remoteURL;
  late final String mediaID;
  late final String userName;
  late final String imagePath;
}

Future<List<StreamsData>> startParse() async {
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
      StreamsData data = StreamsData();

      data.episodeTitle = await currentStream["NowPlayingItem"]["Name"];
      data.releaseYear = await currentStream["NowPlayingItem"]["ProductionYear"];
      data.remoteURL = await currentStream["RemoteEndPoint"];
      data.mediaType = getMediaType(currentStream);
      data.userName = await currentStream["UserName"];
      data.seasonNum = await getSeasonNum(currentStream); // -1 if not a series
      data.episodeNum = await getEpisodeNum(currentStream); // -1 if not a series

      // Build a new StreamsData instance to add to our list
      // Get the series name or the movie name
      if (await currentStream["NowPlayingItem"]["SeriesName"] != null) {
        data.masterName = await currentStream["NowPlayingItem"]["SeriesName"];
      } else {
        data.masterName = await currentStream["NowPlayingItem"]["Name"];
      }

      // Get the seasonId if series, otherwise get Id for movies
      if (data.mediaType == MediaType.episode) {
        data.mediaID = await currentStream["NowPlayingItem"]["SeriesId"];
      } else if (data.mediaType == MediaType.movie) {
        data.mediaID = await currentStream["NowPlayingItem"]["Id"];
      }

      data.imagePath = await GETImage.getItemImageURL(id: data.mediaID);
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

MediaType getMediaType(Map<String, dynamic> stream) {
  /// This function matches the current media type string with a value in MediaType
  ///
  /// If no MediaType is found, MediaType.unknown is returned
  for (int i = 0; i < MediaType.values.length; i++) {
    // Define current MeidaType tag and the current stream's tag
    String currentMediaTag = MediaType.values[i].name.toLowerCase();
    String currentStreamTag = stream["NowPlayingItem"]["Type"].toString().toLowerCase();

    // If the tags match, return the current tag
    if (currentMediaTag == currentStreamTag) {
      return MediaType.values[i];
    }
  }

  // No tag was found, return unknown
  return MediaType.unknown;
}
