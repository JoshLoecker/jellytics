import 'package:flutter/material.dart';
import 'package:jellytics/utils/screens.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/data_classes/libraries.dart';
import 'package:jellytics/data_classes/active_streams.dart';
import 'package:jellytics/views/library/get_library.dart';
import 'package:transparent_image/transparent_image.dart';

class ActivityDetailWidget extends StatefulWidget {
  ActivityDetailWidget({required this.streamData, super.key});

  final StreamsData streamData;
  // final ItemDetailInfoNew itemInfo;
  final SecureStorage secureStorage = SecureStorage();

  @override
  State<ActivityDetailWidget> createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<ActivityDetailWidget> {
  Widget rowDetails(String header, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(5, 5, 3, 5),
          child: Text(
            header,
          ),
        ),
        Flexible(
          child: Text(
            value,
          ),
        ),
      ],
    );
  }

  Widget activityDetails(ItemDetailInfoNew itemInfo) {
    return ListView(
      // These lines are required to limit the vertical viewport of the ListView
      // From:https://stackoverflow.com/questions/50252569
      // scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      children: <Widget>[
        FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(itemInfo.backdropImagePath!),
          width: MediaQuery.of(context).size.width,
          fadeInDuration: const Duration(milliseconds: 200),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            itemInfo.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        rowDetails("Overview:", itemInfo.name),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ItemDetailInfoNew itemInfo = ItemDetailInfoNew(name: widget.streamData.masterName, id: widget.streamData.id, baseItemKind: widget.streamData.)
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.streamData.masterName),
      ),
      body: FutureBuilder(
        future: getLibraryItemDetails(widget.itemInfo, widget.secureStorage),
        builder: (context, AsyncSnapshot<ItemDetailInfoNew> futures) {
          if (futures.hasData) {
            return defaultCard(
                context: context, containerChild: Text(futures.data!.name));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
