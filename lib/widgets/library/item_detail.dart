/// This file contains the widget that displays the details of a media item in the library.

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/models/base.dart';
import 'package:jellytics/models/types/movie.dart';
import 'package:jellytics/models/types/series.dart';

class ItemDetail extends ConsumerStatefulWidget {
  const ItemDetail({required this.model, Key? key}) : super(key: key);

  final BaseModel model;

  @override
  ConsumerState<ItemDetail> createState() => ItemDetailState();
}

class ItemDetailState extends ConsumerState<ItemDetail> with clientFromStorage {
  @override
  void initState() {
    super.initState();
    initClient(ref);
  }

  Widget buildDetails() {
    /// This function will return the appropriate screen based on the type of media
    if (widget.model.type == ItemTypes.movie) {
      return movieBuilder(widget.model, ref);
    } else if (widget.model.type == ItemTypes.series) {
      return SeriesBuilder(widget.model, ref).seriesDetailBuilder();
    } else {
      return Center(
          child: Text(
              "Media type '${widget.model.type.name}' not implemented yet"));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            largeTitle: Text("Media Details"),
          ),
          SliverFillRemaining(
            // child: widget.item.build(ref),
            child: buildDetails(),
          ),
        ],
      ),
    );
  }
}
