/// This file is responsible for gathering and formatting library items (tv shows and movies)

import 'package:jellytics/api/print.dart';
import 'package:jellytics/views/library/query.dart';
import 'package:jellytics/api/paths.dart';
import 'package:jellytics/utils/secure_storage.dart';

class LibrarySuper {
  LibrarySuper({
    required this.name,
    required this.id,
    required this.baseItemKind,
  });
  late final String name;
  late final String id;
  late final BaseItemKind baseItemKind;
}

class LibraryOverviewInfo extends LibrarySuper {
  LibraryOverviewInfo({
    required libraryName,
    required id,
    required baseItemKind,
  }) : super(name: libraryName, id: id, baseItemKind: baseItemKind);
}

class LibraryDetailInfo extends LibrarySuper {
  LibraryDetailInfo({
    required name,
    required id,
    required baseItemKind,
  }) : super(name: name, id: id, baseItemKind: baseItemKind);
}

class ItemDetailInfo extends LibrarySuper {
  late final String imagePath;
  late final String backdropImagePath;
  late final List<dynamic> imageInfo;
  late final String overview;
  late final String genre;
  late final String releaseYear; // ProductionYear
  late final String tmdbId; //ProviderIds["Tmdb"]
  late final String imdb; //ProviderIds["Imdb"]

  ItemDetailInfo({
    required name,
    required id,
    required baseItemKind,
    required this.imagePath,
    required this.backdropImagePath,
    required this.imageInfo,
    required this.overview,
    required this.genre,
    required this.releaseYear,
    required this.tmdbId,
    required this.imdb,
  }) : super(name: name, id: id, baseItemKind: baseItemKind);
}

Future<List<LibraryOverviewInfo>> getUserLibraries() async {
  /// This function will get a list of the user's libraries

  GETLibrary items = GETLibrary();
  Map<String, dynamic> response = await items.getLibraries();
  List<LibraryOverviewInfo> libraries = <LibraryOverviewInfo>[];

  for (var item in response["Items"]) {
    libraries.add(LibraryOverviewInfo(
      libraryName: item["Name"],
      baseItemKind: BaseItemKind.values.firstWhere(
        (element) => element.name.toLowerCase() == item["Type"].toLowerCase(),
      ),
      id: item["Id"],
    ));
  }

  // Sort libraries based on libraryName; from: https://stackoverflow.com/a/53549197
  libraries.sort((a, b) => a.name.compareTo(b.name));
  return libraries;
}

Future<List<LibraryDetailInfo>> getLibraryDetails(
    LibraryOverviewInfo parentInfo) async {
  /// This function will get all items within a library
  ///
  /// id: The ID of the library to gether items for
  GETLibrary items = GETLibrary();
  Map<String, dynamic> response =
      await items.getByParentID(parentInfo: parentInfo);
  List<LibraryDetailInfo> libraryItems = <LibraryDetailInfo>[];

  for (var item in response["Items"]) {
    libraryItems.add(LibraryDetailInfo(
      name: item["Name"],
      baseItemKind: BaseItemKind.values.firstWhere((element) =>
          element.name.toLowerCase() == item["Type"].toLowerCase()),
      id: item["Id"],
    ));
  }
  libraryItems
      .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return libraryItems;
}

Future<ItemDetailInfo> getLibraryItemDetails(
    LibraryDetailInfo itemInfo, SecureStorage secureStorage) async {
  /// This function will get details of a library item (i.e., details of a specific show, movie, etc.)
  ///
  GETLibrary getByID = GETLibrary();
  String backdropImagePath = "";

  List<dynamic> imagePathInfo =
      await GETImage.getImageInfoPath(id: itemInfo.id);
  int backdropImageIndex = imagePathInfo.indexWhere(
      (element) => element["ImageType"].toLowerCase() == "backdrop");
  Map<String, dynamic> idData = await getByID.getByID(itemInfo: itemInfo);

  if (backdropImageIndex != -1) {
    backdropImagePath =
        "${await secureStorage.getServerURL()}/Items/${itemInfo.id}/Images/Backdrop";
  }

  return ItemDetailInfo(
    name: itemInfo.name,
    id: itemInfo.id,
    baseItemKind: itemInfo.baseItemKind,
    imagePath: await GETImage.itemImageURL(id: itemInfo.id),
    backdropImagePath: backdropImagePath,
    imageInfo: imagePathInfo,
    overview: await idData["Overview"],
    genre: await idData["Genres"].join(", "),
    releaseYear: idData["ProductionYear"].toString(),
    tmdbId: await idData["ProviderIds"]["Tmdb"],
    imdb: await idData["ProviderIds"]["Imdb"],
  );
}
