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
