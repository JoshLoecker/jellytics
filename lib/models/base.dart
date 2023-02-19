import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class BaseModel {
  String name;
  String id;
  String parentId;
  String year;
  String type;
  String path;
  String overview;
  ImagePaths imagePaths;

  BaseModel(
      {required this.name,
      required this.id,
      required this.parentId,
      required this.year,
      required this.path,
      required this.type,
      required this.overview,
      required this.imagePaths});
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
