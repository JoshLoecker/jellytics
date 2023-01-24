import 'package:flutter/material.dart';
import 'package:jellytics/utils/screens.dart';
import 'package:jellytics/data_classes/libraries.dart';
import 'package:jellytics/views/library/item_details.dart';
import 'package:jellytics/views/library/get_library.dart';
import 'package:transparent_image/transparent_image.dart';

class LibraryDetails extends StatefulWidget {
  const LibraryDetails({
    super.key,
    required this.libraryData,
  });

  final ItemDetailInfoNew libraryData;

  @override
  State<LibraryDetails> createState() => _LibraryDetailsState();
}

class _LibraryDetailsState extends State<LibraryDetails> {
  Widget libraryDetails(ItemDetailInfoNew itemInfo) {
    // Create a Text widget that wraps words that are too long to fit on one line
    // It should contain itemInfo.name

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LibraryItemDetails(itemInfo: itemInfo)),
        );
      },
      child: defaultCard(
        context: context,
        containerChild: Row(
          children: <Widget>[
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(itemInfo.posterImagePath!),
              fadeInDuration: const Duration(milliseconds: 200),
            ),
            // const Text("Poster"),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                itemInfo.name,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            // Text(itemInfo.name),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.libraryData.name} Library"),
      ),
      body: FutureBuilder(
        future: getLibraryDetails(widget.libraryData),
        builder: (context, AsyncSnapshot<List<ItemDetailInfoNew>> futures) {
          if (futures.hasData) {
            return Scrollbar(
              child: ListView.builder(
                itemCount: futures.data?.length,
                itemBuilder: (context, index) {
                  return defaultCard(
                      context: context,
                      containerChild: Container(
                        alignment: Alignment.center,
                        // child: Text(futures.data![index].name),
                        child: libraryDetails(futures.data![index]),
                      ));
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
