/// This file contains the base model for all media types
/// Calling the 'build' method will return a widget based on the type of media

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/movie.dart';
import 'package:jellytics/models/series.dart';

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

  ImagePaths({
    this.primary = "",
    this.art = "",
    this.backdrop = "",
    this.banner = "",
    this.logo = "",
    this.thumb = "",
    this.disc = "",
    this.box = "",
    this.screenshot = "",
    this.menu = "",
    this.chapter = "",
    this.boxRear = "",
    this.profile = "",
  });
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
  ImagePaths imagePaths;

  BaseModel(
      {required this.name,
      required this.id,
      required this.parentId,
      required this.year,
      required this.path,
      required String type_,
      required this.overview,
      required this.imagePaths}) {
    type = ItemTypes.values.firstWhere(
        (t) => t.name.toString().toLowerCase() == type_.toLowerCase());
  }

  Widget _buildSeries() {
    return Container();
  }

  Widget build(WidgetRef ref) {
    print("Type: $type");
    if (type == ItemTypes.movie) {
      return movieBuilder(this, ref);
    } else if (type == ItemTypes.series) {
      return seasonBuilder(this, ref);
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
