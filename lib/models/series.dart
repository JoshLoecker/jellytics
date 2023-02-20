/// Series model
/// This will build the screens for a series
/// This includes the season details (Season 01, 02, etc), along with the episode details (episode 01, 02, etc)

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/base.dart';

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
