import 'package:flutter/material.dart';
import 'package:jellytics/utils/secure_storage.dart';
import 'package:jellytics/data_classes/active_streams.dart';

class ActivityDetailWidget extends StatefulWidget {
  ActivityDetailWidget({required this.streamData, super.key});

  final StreamsData streamData;
  final SecureStorage secureStorage = SecureStorage();

  @override
  State<ActivityDetailWidget> createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<ActivityDetailWidget> {
  Future<String> getActivtyDetailView() async {
    return "${widget.streamData.masterName}\n${widget.streamData.id}\n${widget.streamData.releaseYear}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.streamData.masterName),
      ),
      body: FutureBuilder(
        future: getActivtyDetailView(),
        builder: (context, AsyncSnapshot<String> futures) {
          if (futures.hasData) {
            return Text(futures.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
