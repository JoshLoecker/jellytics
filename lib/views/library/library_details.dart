import 'package:flutter/material.dart';
import 'package:jellytics/utils/screens.dart';
import 'package:jellytics/views/library/get_library.dart';

class LibraryDetails extends StatefulWidget {
  const LibraryDetails({
    super.key,
    required this.libraryData,
  });

  final SpecificLibraryInfo libraryData;

  @override
  State<LibraryDetails> createState() => _LibraryDetailsState();
}

class _LibraryDetailsState extends State<LibraryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.libraryData.libraryName} Library"),
      ),
      body: FutureBuilder(
        future: getSpecificLibraryItems(widget.libraryData),
        builder: (context, AsyncSnapshot<List<SpecificItemInfo>> futures) {
          if (futures.hasData) {
            return ListView.builder(
              itemCount: futures.data?.length,
              itemBuilder: (context, index) {
                return defaultCard(
                    context: context,
                    containerChild: Container(
                      alignment: Alignment.center,
                      child: Text(futures.data![index].name),
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
