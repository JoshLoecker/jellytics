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
      [this.primary = "",
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
      this.profile = ""]);
}

class BaseModel {
  late final String title;
  final int year;
  final String description;
  ImagePaths imagePaths;

  BaseModel(
      {required this.title,
      required this.year,
      required this.description,
      required this.imagePaths});

  factory BaseModel.fromJson(Map<String, dynamic> json, ImagePaths imagePaths) {
    return BaseModel(
        title: json['Title'],
        year: json['ProductionYear'],
        description: json['Overview'],
        imagePaths: imagePaths);
  }
}
