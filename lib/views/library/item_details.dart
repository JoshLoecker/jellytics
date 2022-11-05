/// This file is to be used to display information about specific items in the library
/// It  will be called from library_details after gathering the specific library's items
import 'package:flutter/material.dart';
import 'package:jellytics/data_classes/libraries.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/views/library/get_library.dart';
import 'package:jellytics/utils/screens.dart';
import 'package:transparent_image/transparent_image.dart';

class LibraryItemDetails extends StatefulWidget {
  LibraryItemDetails({
    super.key,
    required this.itemInfo,
  });

  final LibraryDetailInfo itemInfo;
  final SecureStorage secureStorage = SecureStorage();
  bool noData = false;
  List<String> missingValues = <String>[];

  @override
  State<LibraryItemDetails> createState() => _LibraryItemDetailsState();
}

class _LibraryItemDetailsState extends State<LibraryItemDetails> {
  Widget rowDetails(String header, String? value) {
    if (value == null) {
      widget.missingValues.add(header.replaceAll(":", ""));
      widget.noData = true;
      return const SizedBox.shrink();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 3, 5),
            child: Text(
              header,
            ),
          ),
          Flexible(
            child: Text(
              value,
            ),
          ),
        ],
      );
    }
  }

  Widget itemDetails(ItemDetailInfo itemInfo) {
    return ListView(
      // These lines are required to limit the vertical viewport of the ListView
      // From:https://stackoverflow.com/questions/50252569
      // scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      children: <Widget>[
        FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(itemInfo.backdropImagePath),
          width: MediaQuery.of(context).size.width,
          fadeInDuration: const Duration(milliseconds: 200),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            itemInfo.libraryData.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        rowDetails("Overview:", itemInfo.overview),
        rowDetails("Genres:", itemInfo.genre),
        rowDetails("Release Year:", itemInfo.releaseYear),
        rowDetails("TMDB:", itemInfo.tmdbId),
        rowDetails("IMDb ID:", itemInfo.imdb),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemInfo.libraryData.name),
      ),
      body: FutureBuilder(
        future: getLibraryItemDetails(widget.itemInfo, widget.secureStorage),
        builder: (context, AsyncSnapshot<ItemDetailInfo> futures) {
          if (futures.hasData) {
            return itemDetails(futures.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
