/// This file is responsible for defining the default "card" that will show:
/// - libraries (such as Movies, TV, etc.)
/// - Specific library items (such as a movie, a TV show, etc.)

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:jellytics/utils/interface.dart' as ui;

Widget cardContainer(
  Widget child, {
  double maxCardHeight = 125,
  EdgeInsets margin = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
}) {
  return SafeArea(
    child: Container(
      margin: margin,
      constraints: BoxConstraints.expand(
        width: ui.safeWidth(),
        height: maxCardHeight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: child,
      ),
    ),
  );
}
