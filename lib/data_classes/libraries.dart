import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:jellytics/views/library/query.dart';
part 'libraries.freezed.dart';

/// Can't use "extends", as freezed doesn't support it
/// From: https://github.com/rrousselGit/freezed/issues/464

@freezed
class LibrarySuper with _$LibrarySuper {
  const factory LibrarySuper({
    required String name,
    required String id,
    required BaseItemKind baseItemKind,
  }) = _LibrarySuper;
}

@freezed
class LibraryOverviewInfo with _$LibraryOverviewInfo {
  const factory LibraryOverviewInfo({
    required LibrarySuper libraryData,
  }) = _LibraryOverviewInfo;
}

@freezed
class LibraryDetailInfo with _$LibraryDetailInfo {
  const factory LibraryDetailInfo({
    required LibrarySuper libraryData,
  }) = _LibraryDetailInfo;
}

@freezed
class ItemDetailInfo with _$ItemDetailInfo {
  const factory ItemDetailInfo({
    required LibrarySuper libraryData,
    required String imagePath,
    required String backdropImagePath,
    required List<dynamic> imageInfo,
    required String? overview,
    required String? genre,
    required String? releaseYear, // ProductionYear
    required String? tmdbId, //ProviderIds["Tmdb"]
    required String? imdb, //ProviderIds["Imdb"]
  }) = _ItemDetailInfo;
}
