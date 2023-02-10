import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/base.dart';
import 'package:jellytics/utils/print.dart';

class ItemDetail extends ConsumerStatefulWidget {
  const ItemDetail({required this.item, Key? key}) : super(key: key);

  final BaseModel item;

  @override
  ConsumerState<ItemDetail> createState() => ItemDetailState();
}

class ItemDetailState extends ConsumerState<ItemDetail> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildMovie() {
    Map<String, String> itemDetails = {
      "Name": widget.item.name,
      "Release Year": widget.item.year,
      "Filename": widget.item.path.split("/").last,
      "Path": widget.item.path,
    };

    return Center(
      child: Column(
        children: <Widget>[
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.8, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: Image.network(
                widget.item.imagePaths.backdrop,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              SizedBox(
                width: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                        .size
                        .width /
                    10,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    for (String label in itemDetails.keys)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            label,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                  ]),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (String value in itemDetails.values)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Set a text wrap
                        Text(value, softWrap: true),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSeries() {
    return Text("Series");
  }

  Future<Widget> buildListItems() async {
    if (widget.item.type == "Movie") {
      return buildMovie();
    } else if (widget.item.type == "Series") {
      return buildSeries();
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
