/// This file contains the base model for all media types
/// Calling the 'build' method will return a widget based on the type of media

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/types/movie.dart';
import 'package:jellytics/models/types/series.dart';
import 'package:jellytics/providers/server_details.dart';

class ImagePaths {
  late String primary;
  late String art;
  late String backdrop;
  late String banner;
  late String logo;
  late String thumb;
  late String disc;
  late String box;
  late String screenshot;
  late String menu;
  late String chapter;
  late String boxRear;
  late String profile;

  ImagePaths(
    String fullIPAddress,
    String id,
  ) {
    primary = "$fullIPAddress/Items/$id/Images/Primary";
    art = "$fullIPAddress/Items/$id/Images/Art";
    backdrop = "$fullIPAddress/Items/$id/Images/Backdrop";
    banner = "$fullIPAddress/Items/$id/Images/Banner";
    logo = "$fullIPAddress/Items/$id/Images/Logo";
    thumb = "$fullIPAddress/Items/$id/Images/Thumb";
    disc = "$fullIPAddress/Items/$id/Images/Disc";
    box = "$fullIPAddress/Items/$id/Images/Box";
    screenshot = "$fullIPAddress/Items/$id/Images/Screenshot";
    menu = "$fullIPAddress/Items/$id/Images/Menu";
    chapter = "$fullIPAddress/Items/$id/Images/Chapter";
    boxRear = "$fullIPAddress/Items/$id/Images/BoxRear";
    profile = "$fullIPAddress/Items/$id/Images/Profile";
  }
}

enum ItemTypes {
  aggregateFolder,
  audio,
  audioBook,
  basePluginFolder,
  book,
  boxSet,
  channel,
  channelFolderItem,
  collectionFolder,
  episode,
  folder,
  genre,
  manualPlaylistsFolder,
  movie,
  liveTvChannel,
  liveTvProgram,
  musicAlbum,
  musicArtist,
  musicGenre,
  musicVideo,
  person,
  photo,
  photoAlbum,
  playlist,
  playlistsFolder,
  program,
  recording,
  season,
  series,
  studio,
  trailer,
  tvChannel,
  tvProgram,
  userRootFolder,
  userView,
  video,
  year,
}

class BaseModel {
  String name;
  String id;
  String parentId;
  String year;
  late ItemTypes type;
  String path;
  String overview;
  late ImagePaths imagePaths;
  WidgetRef ref;

  BaseModel({
    required this.name,
    required this.id,
    required this.parentId,
    required this.year,
    required this.path,
    required String type_,
    required this.overview,
    required this.ref,
  }) {
    imagePaths = ImagePaths(
        ref.watch(serverDetailsProvider.notifier
            .select((value) => value.fullAddress)),
        id);
    type = ItemTypes.values.firstWhere(
        (t) => t.name.toString().toLowerCase() == type_.toLowerCase());
  }

  Widget build(WidgetRef ref) {
    if (type == ItemTypes.movie) {
      return movieBuilder(this, ref);
    } else if (type == ItemTypes.series) {
      return SeriesBuilder(this, ref).seriesDetailBuilder();
    } else {
      return Center(
          child: Text("Media type '${type.name}' not implemented yet!"));
    }
  }
}

Row rowItem(String title, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            textPadding(title, makeGrey: true),
          ],
        ),
      ),
      const SizedBox(width: 10),
      Flexible(
        flex: 2,
        child: Column(
          children: <Widget>[
            textPadding(value, makeGrey: false),
          ],
        ),
      ),
      const SizedBox(width: 20),
    ],
  );
}

Padding textPadding(String text, {bool makeGrey = false, double? textSize}) {
  if (makeGrey) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(text),
    );
  }
}
