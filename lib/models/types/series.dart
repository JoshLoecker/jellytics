/// Series model
/// This will build the screens for a series
/// This includes the season details (Season 01, 02, etc), along with the episode details (episode 01, 02, etc)

import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/providers/server_details.dart';
import 'package:jellytics/models/base.dart';

import 'package:jellytics/utils/print.dart';

class SeasonModel extends BaseModel {
  String seriesName;
  String seriesId;

  SeasonModel({
    required String name,
    required String id,
    required String parentId,
    required String year,
    required String path,
    required String type_,
    required String overview,
    required ImagePaths imagePaths,
    required this.seriesName,
    required this.seriesId,
  }) : super(
          name: name,
          id: id,
          parentId: parentId,
          year: year,
          path: path,
          type_: type_,
          overview: overview,
          imagePaths: imagePaths,
        );
}

class SeriesBuilder {
  BaseModel model;
  WidgetRef ref;
  SeriesBuilder(this.model, this.ref);

  Future<List<SeasonModel>> getSeriesDetails() async {
    Map<String, dynamic> seriesDetails =
        await ref.read(clientDetailsProvider.notifier).dio.get(
      "/Items",
      queryParameters: {
        "userId": ref.read(serverDetailsProvider.notifier).userId,
        "parentId": model.id,
        "sortOrder": "Ascending",
        "sortBy": "SortName",
        "fields": "Overview,Type,Path,SeasonUserData",
      },
    ).then((value) => value.data);

    List<SeasonModel> seasons = [];
    for (var item in seriesDetails["Items"]) {
      if (item["Type"] == "Season") {
        seasons.add(
          SeasonModel(
            name: item["Name"],
            id: item["Id"],
            parentId: model.id,
            year: item["ProductionYear"].toString(),
            path: item["Path"],
            type_: item["Type"],
            overview: "",
            imagePaths: ImagePaths(
              ref.read(serverDetailsProvider.notifier).fullAddress,
              item["Id"],
            ),
            seriesName: item["SeriesName"],
            seriesId: item["SeriesId"],
          ),
        );
      }
    }
    return seasons;
  }

  Future<Widget> buildSeriesDeatils() async {
    List<SeasonModel> seasons = await getSeriesDetails();
    return ListView.builder(
      itemCount: seasons.length,
      itemBuilder: (BuildContext context, int index) {
        return Text(seasons[index].name);
      },
    );
  }

  Future<void> buildSeasonDetails() async {}

  Widget seriesDetailBuilder() {
    return FutureBuilder(
      future: getSeriesDetails(),
      builder:
          (BuildContext context, AsyncSnapshot<List<SeasonModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("No connection!");
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CupertinoActivityIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return CupertinoListSection(
                children: List.from(
                  snapshot.data!.map<Widget>(
                    (item) => CupertinoListTile(
                      title: Text(item.name),
                      leading: Image.network(
                        item.imagePaths.primary,
                        fit: BoxFit.cover,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      additionalInfo: Text(item.year),
                      // set size of leading item
                      leadingSize: 200,
                      leadingToTitle: 0.0,
                      padding: const EdgeInsets.all(0),
                      onTap: () {
                        print("Tapped on ${item.name}");
                      },
                    ),
                  ),
                ),
              );
            }
        }
      },
    );
  }
}

Widget seasonBuilder(BaseModel model, WidgetRef ref) {
  return ListView(
    // Add padding to the bottom to allow for the bottom navigation bar
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
    // Create a list of numbers
    children: List.of(
      <Widget>[
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
                stops: const [0.0, 0.7, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: Image.network(
              model.imagePaths.backdrop,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Set font family to sans serif
              const Text("Summary", style: TextStyle(color: Colors.grey)),
              Text(model.overview, softWrap: true),
            ],
          ),
        ),
        rowItem("TITLE", model.name),
        rowItem("RELEASE YEAR", model.year),
        rowItem("FILENAME", model.path.split("/").last),
        rowItem("PATH", model.path),
      ],
    ),
  );
}

Widget episodeBuilder() {
  return Container();
}
