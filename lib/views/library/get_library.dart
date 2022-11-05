/// This file is responsible for gathering and formatting library items (tv shows and movies)

import 'package:jellytics/api/paths.dart';
import 'package:jellytics/views/library/query.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/data_classes/libraries.dart';

Future<List<LibraryOverviewInfo>> getUserLibraries() async {
  /// This function will get a list of the user's libraries

  GETLibrary items = GETLibrary();
  Map<String, dynamic> response = await items.getLibraries();
  List<LibraryOverviewInfo> libraries = <LibraryOverviewInfo>[];

  // Exclude collections from the list of libraries
  for (var item in response["Items"]) {
    if (item["CollectionType"].toString().toLowerCase() == "boxsets") {
      continue;
    }
    libraries.add(
      LibraryOverviewInfo(
        libraryData: LibrarySuper(
          name: item["Name"],
          id: item["Id"],
          baseItemKind: BaseItemKind.values.firstWhere(
            (element) =>
                element.name.toLowerCase() == item["Type"].toLowerCase(),
          ),
        ),
      ),
    );
  }

  // Sort libraries based on libraryName; from: https://stackoverflow.com/a/53549197
  libraries.sort((a, b) => a.libraryData.name.compareTo(b.libraryData.name));
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
    // Exclude collections from the list of movies (i.e., boxsets)
    if (item["Type"].toString().toLowerCase() == "boxset") {
      continue;
    }

    libraryItems.add(
      LibraryDetailInfo(
        libraryData: LibrarySuper(
          name: item["Name"],
          id: item["Id"],
          baseItemKind: BaseItemKind.values.firstWhere(
            (element) =>
                element.name.toLowerCase() == item["Type"].toLowerCase(),
          ),
        ),
      ),
    );
  }
  libraryItems.sort((a, b) => a.libraryData.name
      .toLowerCase()
      .compareTo(b.libraryData.name.toLowerCase()));
  return libraryItems;
}

Future<ItemDetailInfo> getLibraryItemDetails(
    LibraryDetailInfo itemInfo, SecureStorage secureStorage) async {
  /// This function will get details of a library item (i.e., details of a specific show, movie, etc.)
  ///
  GETLibrary getByID = GETLibrary();
  Map<String, dynamic> idData = await getByID.getByID(itemInfo: itemInfo);
  List<dynamic> imagePathInfo =
      await GETImage.getImageInfoPath(id: itemInfo.libraryData.id);
  int backdropImageIndex = imagePathInfo.indexWhere(
      (element) => element["ImageType"].toLowerCase() == "backdrop");

  String release = idData["ProductionYear"].toString();

  ItemDetailInfo data = ItemDetailInfo(
    libraryData: LibrarySuper(
      name: itemInfo.libraryData.name,
      id: itemInfo.libraryData.id,
      baseItemKind: itemInfo.libraryData.baseItemKind,
    ),
    imageInfo: imagePathInfo,
    imagePath: await GETImage.itemImageURL(id: itemInfo.libraryData.id),
    imdb: await idData["ProviderIds"]["Imdb"],
    overview: await idData["Overview"],
    releaseYear: release == "null" ? null : release,
    tmdbId: await idData["ProviderIds"]["Tmdb"],
    backdropImagePath: backdropImageIndex != -1
        ? "${await secureStorage.getServerURL()}/Items/${itemInfo.libraryData.id}/Images/Backdrop"
        : "",
    genre: idData["Genres"].toString() == "[]" // empty list. How to compare?
        ? null
        : idData["Genres"].join(", "),
  );

  return data;
}
