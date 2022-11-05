import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'active_streams.freezed.dart';

enum MediaFormat { movie, episode, unknown }

@freezed
class StreamsData with _$StreamsData {
  const factory StreamsData({
    required String episodeTitle,
    required int releaseYear,
    required String remoteURL,
    required MediaFormat mediaType,
    required String userName,
    required int seasonNum,
    required int episodeNum,
    required String masterName,
    required String id,
    required String imagePath,
    // late final int completionPercentage; // Not everything shows completion percentage under NowPlayingItem. Not sure why.
  }) = _StreamsData;
}
