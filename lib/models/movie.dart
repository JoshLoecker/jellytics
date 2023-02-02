import 'package:jellytics/models/base.dart';

// Create a class that extends BaseModel calld MovieTest
class Movie extends BaseModel {
  Movie(
      {required String title,
      required int year,
      required String description,
      required ImagePaths imagePaths})
      : super(
            title: title,
            year: year,
            description: description,
            imagePaths: imagePaths);

  factory Movie.fromParameters(
      {required String title,
      required int year,
      required String description,
      required ImagePaths imagePaths}) {
    return Movie(
        title: title,
        year: year,
        description: description,
        imagePaths: imagePaths);
  }
}
