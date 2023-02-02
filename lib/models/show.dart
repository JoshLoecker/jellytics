import 'package:jellytics/models/base.dart';

// Create a class that extends BaseModel calld MovieTest
class Show extends BaseModel {
  Show(
      {required String title,
      required int year,
      required String description,
      required ImagePaths imagePaths})
      : super(
            title: title,
            year: year,
            description: description,
            imagePaths: imagePaths);

  factory Show.fromParameters(
      {required String title,
      required int year,
      required String description,
      required ImagePaths imagePaths}) {
    return Show(
        title: title,
        year: year,
        description: description,
        imagePaths: imagePaths);
  }
}
