import 'dart:core';
import 'package:flutter/material.dart';

Widget defaultCard({
  required BuildContext context,
  required Widget containerChild,
  double maxCardHeight = 125,
}) {
  return ConstrainedBox(
    constraints: BoxConstraints.expand(
      width: safeWidth(context),
      height: maxCardHeight,
    ),
    child: Container(
        decoration: BoxDecoration(
          // Set color of card background based on light/dark mode
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.grey[350]
              : Colors.grey[500],
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: containerChild),
  );
}

double safeWidth(BuildContext context) {
  // Get the width of the safe area and subtract the left/right padding from it
  // The resulting value is the maximum safe width we can make our widgets
  double screenWidth = MediaQuery.of(context).size.width;
  double paddingWidth = MediaQuery.of(context).padding.right * 2;
  double maxSafeWidth = screenWidth - paddingWidth;
  return maxSafeWidth;
}
