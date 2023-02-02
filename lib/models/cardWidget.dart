/*
This file is responsible for defining the default "card" that will show:
- libraries (such as Movies, TV, etc.)
- Specific library items (such as a movie, a TV show, etc.)
*/
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:jellytics/utils/interface.dart' as ui;

Widget cardContainer(Widget child, {double maxCardHeight = 200}) {
  return Container(
    constraints: BoxConstraints.expand(
      width: ui.safeWidth(),
      height: maxCardHeight,
    ),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      // Set color of card background based on light/dark mode
      color: ui.isDarkMode() ? Colors.grey[350] : Colors.grey[500],
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: child,
  );
}

Widget card(String title) {
  return Text(title);
}
