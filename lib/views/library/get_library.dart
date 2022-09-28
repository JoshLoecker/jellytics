/// This file is responsible for gathering and formatting library items (tv shows and movies)

import 'package:jellytics/views/library/query.dart';
import 'package:jellytics/api/paths.dart';

Future<void> getLibraryItems({required BaseItemKind itemKind}) async {
  /// This function will parse results from paths.getItems into a format that is usable by library.dart
  GETLibrary items = GETLibrary();
  await items.getItems(
      includeKind: <BaseItemKind>[BaseItemKind.movie], fields: <Field>[Field.path]);
}
