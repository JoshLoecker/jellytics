/// This file is responsible for gathering and formatting library items (tv shows and movies)

import 'package:jellytics/views/library/query.dart';
import 'package:jellytics/api/paths.dart';

class SpecificLibraryInfo {
  SpecificLibraryInfo({
    required this.libraryName,
    required this.baseItemKind,
    required this.id,
  });

  late final String libraryName;
  late final BaseItemKind baseItemKind;
  late final String id;
}

class SpecificItemInfo {
  SpecificItemInfo({
    required this.name,
    required this.baseItemKind,
    required this.id,
  });

  late final String name;
  late final BaseItemKind baseItemKind;
  late final String id;
}

Future<List<SpecificLibraryInfo>> getUserLibraries() async {
  /// This function will get a list of the user's libraries

  GETLibrary items = GETLibrary();
  Map<String, dynamic> response = await items.getLibraries();
  List<SpecificLibraryInfo> libraries = <SpecificLibraryInfo>[];

  for (var item in response["Items"]) {
    libraries.add(SpecificLibraryInfo(
      libraryName: item["Name"],
      baseItemKind: BaseItemKind.values.firstWhere(
        (element) => element.name.toLowerCase() == item["Type"].toLowerCase(),
      ),
      id: item["Id"],
    ));
  }

  // Sort libraries based on libraryName; from: https://stackoverflow.com/a/53549197
  libraries.sort((a, b) => a.libraryName.compareTo(b.libraryName));
  return libraries;
}

Future<List<SpecificItemInfo>> getSpecificLibraryItems(
    SpecificLibraryInfo parentInfo) async {
  /// This function will get all items within a library
  ///
  /// id: The ID of the library to gether items for
  GETLibrary items = GETLibrary();
  Map<String, dynamic> response =
      await items.getByParentID(parentInfo: parentInfo);
  List<SpecificItemInfo> libraryItems = <SpecificItemInfo>[];

  for (var item in response["Items"]) {
    libraryItems.add(SpecificItemInfo(
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
