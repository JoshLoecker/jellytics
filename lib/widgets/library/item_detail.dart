import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/models/base.dart';
import 'package:jellytics/models/movie.dart';
import 'package:jellytics/models/series.dart';
import 'package:jellytics/utils/print.dart';

class ItemDetail extends ConsumerStatefulWidget {
  const ItemDetail({required this.item, Key? key}) : super(key: key);

  final BaseModel item;

  @override
  ConsumerState<ItemDetail> createState() => ItemDetailState();
}

class ItemDetailState extends ConsumerState<ItemDetail> with clientFromStorage {
  @override
  void initState() {
    super.initState();
    initClient(ref);
  }

  Future<Widget> buildListItems() async {
    if (widget.item.type == "Movie") {
      return movieBuilder(widget.item, ref);
    } else if (widget.item.type == "Series") {
      return seriesBuilder(ref);
    } else {
      return Container(
          alignment: Alignment.center,
          child: Text(
              "Item is not a movie or series.\nOther items coming soon.\n\nCurrent item type: ${widget.item.type}"));
    }
  }

  Widget buildLibraryList() {
    return FutureBuilder(
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Media Details"),
      ),
      child: SafeArea(
        child: buildLibraryList(),
      ),
    );
  }
}
