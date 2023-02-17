import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/base.dart';

Widget movieBuilder(BaseModel model, WidgetRef ref) {
  return Column(
    children: <Widget>[
      // Top Image
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
      // Summary
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
      // Item Details
      Row(
        children: <Widget>[
          SizedBox(
            width: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .size
                    .height /
                10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const <Widget>[
              Text("Title", style: TextStyle(color: Colors.grey)),
              Text("Release Year", style: TextStyle(color: Colors.grey)),
              Text("Filename", style: TextStyle(color: Colors.grey)),
              Text("Path", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            children: <Widget>[
              Text(model.name),
              Text(model.year),
              Text(model.path.split("/").last),
              Text(model.path),
            ],
          ),
          SizedBox(
            width: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .size
                    .width /
                10,
          ),
        ],
      ),
    ],
  );
}
