import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellytics/views/library/get_library.dart';
import 'package:jellytics/views/library/query.dart';

class _LibraryWidget extends StatefulWidget {
  const _LibraryWidget();

  @override
  State<_LibraryWidget> createState() => _LibraryState();
}

class _LibraryState extends State<_LibraryWidget> {
  //Future<void> getLibraries() async {
  //  GETLibrary items = GETLibrary();
  //  await items.getLibraries();
  //}

  Future<void> getUserMovies() async {
    await getLibraryItems(itemKind: BaseItemKind.movie);
  }

  @override
  Widget build(BuildContext context) {
    // In debug mode!
    if (kDebugMode) {
      // Use a GridView.list
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //ElevatedButton(
          //  onPressed: getLibraries,
          //  child: const Text("Get Libraries"),
          //),
          ElevatedButton(
            onPressed: getUserMovies,
            child: const Text("Get User Movies"),
          ),
          const Text("Some stuff"),
        ],
      );

      // In production mode!
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            "Index 1: Library",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Sorry, this screen isn't set up yet."),
        ],
      );
    }
  }
}

const Widget libraryContent = _LibraryWidget();
