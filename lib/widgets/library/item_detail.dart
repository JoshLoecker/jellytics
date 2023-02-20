/// This file contains the widget that displays the details of a media item in the library.

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/models/base.dart';
import 'package:jellytics/models/movie.dart';
import 'package:jellytics/models/series.dart';

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            largeTitle: Text("Media Details"),
          ),
          SliverFillRemaining(
            child: widget.item.build(ref),
          ),
        ],
      ),
    );
  }
}
