import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/card_widget.dart';
import 'package:jellytics/models/base.dart';
import 'package:jellytics/providers/server_details.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/widgets/library/item_detail.dart';
import 'package:jellytics/utils/storage.dart' as storage;

class LibraryDetail extends ConsumerStatefulWidget {
  const LibraryDetail(
      {required this.libraryName, required this.libraryId, Key? key})
      : super(key: key);

  // Define libraryName
  final String libraryName;
  final String libraryId;

  @override
  ConsumerState<LibraryDetail> createState() => LibraryDetailState();
}

class LibraryDetailState extends ConsumerState<LibraryDetail>
    with clientFromStorage {
  @override
  void initState() {
    super.initState();
    initClient(ref);
  }

  Future<Widget> detailItems() async {
    // final serverDetails = ref.watch(server.serverDetailsProvider);
    Map<String, dynamic> libraryItemsJSON =
        await ref.read(clientDetailsProvider.notifier).dio.get(
      "/Items",
      queryParameters: {
        "userId": ref.read(serverDetailsProvider.notifier).userId,
        "parentId": widget.libraryId,
        "sortOrder": "Ascending",
        "sortBy": "SortName",
        "fields": "Overview,Type,Path",
      },
    ).then((value) => value.data);

    List<BaseModel> libraryItems = [];
    for (var i = 0; i < libraryItemsJSON["TotalRecordCount"]; i++) {
      Map<String, dynamic> currentItem = libraryItemsJSON["Items"][i];
      String name = currentItem["Name"];
      String id = currentItem["Id"];
      String year = currentItem["ProductionYear"].toString();
      String overview = currentItem["Overview"] ?? "";
      String type = currentItem["Type"];
      String path = currentItem["Path"];
      ImagePaths imagePaths = ImagePaths(
        ref.read(serverDetailsProvider.notifier).fullAddress,
        id,
      );
      BaseModel model = BaseModel(
        name: name,
        id: id,
        parentId: widget.libraryId,
        year: year,
        path: path,
        type_: type,
        overview: overview,
        imagePaths: imagePaths,
      );
      libraryItems.add(model);
    }

    return ListView.builder(
      itemCount: libraryItemsJSON["TotalRecordCount"],
      itemBuilder: (BuildContext context, int index) {
        return cardContainer(
          Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ItemDetail(
                      model: libraryItems[index],
                    ),
                  ),
                );
              },
              child: Stack(
                // fit: StackFit.passthrough,
                fit: StackFit.expand,
                children: [
                  // Set the image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      libraryItems[index].imagePaths.backdrop,
                      fit: BoxFit.cover,
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            libraryItems[index].imagePaths.primary,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          libraryItems[index].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildLibraryDetails() {
    return FutureBuilder(
      // future: getLibraryItems(),
      future: detailItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("No connection");
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CupertinoActivityIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              String error = "";
              // Perform error handling
              if (snapshot.error.toString().contains("No element")) {
                error = "No items found";
              } else {
                error = snapshot.error.toString();
              }
              return Center(child: Text(error));
            } else {
              return snapshot.data;
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(widget.libraryName)),
      child: SafeArea(
        child: buildLibraryDetails(),
      ),
    );
  }
}
