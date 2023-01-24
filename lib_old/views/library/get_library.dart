/// This file is responsible for gathering and formatting library items (tv shows and movies)

import 'package:jellytics/api/paths.dart';
import 'package:jellytics/api/print.dart';
import 'package:jellytics/views/library/query.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/data_classes/libraries.dart';

Future<List<ItemDetailInfoNew>> getUserLibraries() async {
  /// This function will get a list of the user's libraries
  GETLibrary items = GETLibrary();
  Map<String, dynamic> response = await items.getLibraries();
  List<ItemDetailInfoNew> libraries = <ItemDetailInfoNew>[];

  // Exclude collections from the list of libraries
  for (var item in response["Items"]) {
    if (item["CollectionType"].toString().toLowerCase() == "boxsets") {
      continue;
    }
    libraries.add(
      ItemDetailInfoNew(
        name: item["Name"],
        id: item["Id"],
        baseItemKind: BaseItemKind.values.firstWhere(
          (element) => element.name.toLowerCase() == item["Type"].toLowerCase(),
        ),
      ),
    );
  }

  // Sort libraries based on their name; from: https://stackoverflow.com/a/53549197
  libraries.sort((a, b) => a.name.compareTo(b.name));
  return libraries;
}

Future<List<ItemDetailInfoNew>> getLibraryDetails(
    ItemDetailInfoNew parentInfo) async {
  /// This function will get all items within a library
  ///
  /// id: The ID of the library to gether items for
  GETLibrary items = GETLibrary();
  Map<String, dynamic> response =
      await items.getByParentID(parentInfo: parentInfo);
  List<ItemDetailInfoNew> library = <ItemDetailInfoNew>[];

  for (var item in response["Items"]) {
    // Exclude collections from the list of movies (i.e., boxsets)
    if (item["Type"].toString().toLowerCase() == "boxset") {
      continue;
    }

    library.add(
      ItemDetailInfoNew(
        name: item["Name"],
        id: item["Id"],
        baseItemKind: BaseItemKind.values.firstWhere(
          (element) =>
              element.name.toLowerCase() ==
              item["Type"].toString().toLowerCase(),
        ),
        posterImagePath: await GETImage.itemImageURL(id: item["Id"]),
      ),
    );
  }
  library.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return library;
}

Future<ItemDetailInfoNew> getLibraryItemDetails(
    ItemDetailInfoNew itemInfo, SecureStorage secureStorage) async {
  /// This function will get details of a library item (i.e., details of a specific show, movie, etc.)
  ///
  GETLibrary getByID = GETLibrary();
  Map<String, dynamic> idData = await getByID.getByID(itemInfo: itemInfo);
  List<dynamic> imagePathInfo =
      await GETImage.getImageInfoPath(id: itemInfo.id);
  int backdropImageIndex = imagePathInfo.indexWhere(
      (element) => element["ImageType"].toLowerCase() == "backdrop");

  String release = idData["ProductionYear"].toString();

  ItemDetailInfoNew itemData = ItemDetailInfoNew(
    name: itemInfo.name,
    id: itemInfo.id,
    baseItemKind: itemInfo.baseItemKind,
    imageInfo: imagePathInfo,
    posterImagePath: await GETImage.itemImageURL(id: itemInfo.id),
    imdbID: await idData["ProviderIds"]["Imdb"],
    overview: await idData["Overview"],
    releaseYear: release == "null" ? null : release,
    tmdbID: await idData["ProviderIds"]["Tmdb"],
    backdropImagePath: backdropImageIndex != -1
        ? "${await secureStorage.getServerURL()}/Items/${itemInfo.id}/Images/Backdrop"
        : "",
    genre: idData["Genres"].toString() == "[]" // empty list. How to compare?
        ? null
        : idData["Genres"].join(", "),
  );

  return itemData;
}
