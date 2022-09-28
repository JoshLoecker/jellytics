import 'package:flutter/material.dart';

class _LibraryWidget extends StatefulWidget {
  const _LibraryWidget();

  @override
  State<_LibraryWidget> createState() => _LibraryState();
}

class _LibraryState extends State<_LibraryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Text(
          "Index 1: Library",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("Sorry, this screen isn't set up yet."),
      ],
    );
  }
}

const Widget libraryContent = _LibraryWidget();
