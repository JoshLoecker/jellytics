import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/card_widget.dart';
import 'package:jellytics/models/base.dart';
import 'package:jellytics/providers/server_details.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/widgets/library/item_detail.dart';

class LibraryDetail extends ConsumerStatefulWidget {
  const LibraryDetail({
    required this.libraryName,
    required this.libraryId,
    Key? key,
  }) : super(key: key);

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

  Future<Map<String, dynamic>> getLibraryJSON() async {
    return await ref.read(clientDetailsProvider.notifier).dio.get(
      "/Items",
      queryParameters: {
        "userId": ref.read(serverDetailsProvider.notifier).userId,
        "parentId": widget.libraryId,
        "sortOrder": "Ascending",
        "sortBy": "SortName",
        "fields": "Overview,Type,Path",
      },
    ).then((value) => value.data);
  }

  Future<Widget> detailItems() async {
    Map<String, dynamic> libraryItemsJSON = await getLibraryJSON();
    List<BaseModel> libraryItems = [];
    for (var i = 0; i < libraryItemsJSON["TotalRecordCount"]; i++) {
      Map<String, dynamic> currentItem = libraryItemsJSON["Items"][i];
      libraryItems.add(BaseModel(
        name: currentItem["Name"],
        id: currentItem["Id"],
        parentId: widget.libraryId,
        year: currentItem["ProductionYear"].toString(),
        path: currentItem["Path"],
        type_: currentItem["Type"],
        overview: currentItem["Overview"] ?? "",
        ref: ref,
      ));
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
                fit: StackFit.expand,
                children: [
                  // Set the image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: libraryItems[index].imagePaths.backdrop,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.black,
                      ),
                      placeholderFadeInDuration:
                          const Duration(milliseconds: 0),
                      fadeOutDuration: const Duration(milliseconds: 0),
                      fadeOutCurve: Curves.linear,
                      fadeInCurve: Curves.linear,
                      fadeInDuration: const Duration(milliseconds: 0),
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
                          child: CachedNetworkImage(
                            imageUrl: libraryItems[index].imagePaths.primary,
                            fit: BoxFit.cover,
                            // Make the placeholder a black box
                            placeholder: (context, url) => Container(
                              color: Colors.black,
                            ),
                            placeholderFadeInDuration:
                                const Duration(milliseconds: 0),
                            fadeOutCurve: Curves.linear,
                            fadeOutDuration: const Duration(milliseconds: 0),
                            fadeInCurve: Curves.linear,
                            fadeInDuration: const Duration(milliseconds: 0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              libraryItems[index].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              libraryItems[index].year,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
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

  void showSortOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text("Sort by"),
          actions: <Widget>[
            // Show a multi select menu with sort options
            CupertinoActionSheetAction(
              child: const Text("Name (A → Z)"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text("Year (Oldest → Newest)"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.libraryName),
        trailing: CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: const Icon(CupertinoIcons.sort_down, size: 30),
          onPressed: () {
            showSortOptions();
          },
        ),
      ),
      child: SafeArea(
        child: CupertinoPageScaffold(
          child: FutureBuilder(
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
          ),
        ),
      ),
    );
  }
}
