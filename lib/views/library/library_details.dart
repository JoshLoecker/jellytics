import 'package:flutter/material.dart';
import 'package:jellytics/utils/screens.dart';
import 'package:jellytics/views/library/item_details.dart';
import 'package:jellytics/views/library/get_library.dart';

class LibraryDetails extends StatefulWidget {
  const LibraryDetails({
    super.key,
    required this.libraryData,
  });

  final LibraryOverviewInfo libraryData;

  @override
  State<LibraryDetails> createState() => _LibraryDetailsState();
}

class _LibraryDetailsState extends State<LibraryDetails> {
  Widget libraryDetails(LibraryDetailInfo itemInfo) {
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
        containerChild: Container(
          alignment: Alignment.center,
          child: Text(itemInfo.name.toString()),
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
        builder: (context, AsyncSnapshot<List<LibraryDetailInfo>> futures) {
          if (futures.hasData) {
            return ListView.builder(
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
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
