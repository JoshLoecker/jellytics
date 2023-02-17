import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/cardWidget.dart';
import 'package:jellytics/models/base.dart';
import 'package:jellytics/providers/serverDetails.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/widgets/library/item_detail.dart';

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

  Future<Widget> buildListItems() async {
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
        primary:
            "${ref.read(serverDetailsProvider.notifier).fullAddress}/Items/$id/Images/Primary",
        backdrop:
            "${ref.read(serverDetailsProvider.notifier).fullAddress}/Items/$id/Images/Backdrop",
      );
      BaseModel model = BaseModel(
        name: name,
        id: id,
        parentId: widget.libraryId,
        year: year,
        path: path,
        type: type,
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
                      item: libraryItems[index],
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

  Widget buildLibraryList() {
    return FutureBuilder(
      // future: getLibraryItems(),
      future: buildListItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("No connection");
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CupertinoActivityIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
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
        child: buildLibraryList(),
      ),
    );
  }
}
