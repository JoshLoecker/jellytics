import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellytics/api/end_points.dart';

Widget title = Container();

class MediaUpdateText extends StatefulWidget {
  const MediaUpdateText({Key? key}) : super(key: key);

  @override
  State<MediaUpdateText> createState() => _MediaUpdateText();
}

class _MediaUpdateText extends State<MediaUpdateText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}

class AppLayoutTutorial extends StatelessWidget {
  const AppLayoutTutorial({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(30),
      //color: Colors.pink[50],
      child: Center(
        child: Row(
          children: [
            Column(
              children: const [
                Text("Oeschinen Lake Campground"),
                Text(
                  "Kandersteg, Switzerland",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            Row(children: const [
              Icon(
                Icons.star,
                color: Colors.red,
              ),
              Text("41")
            ])
          ],
        ),
      ),
    );

    Widget buttonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonRow(Colors.blue, Icons.call, "CALL"),
        _buildButtonRow(Colors.blue, Icons.near_me, "ROUTE"),
        _buildButtonRow(Colors.blue, Icons.share, "SHARE"),
      ],
    );

    Widget textSection = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        "Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.",
        softWrap: true,
      ),
    );

    Widget getMediaTokenData = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonRow(Colors.blue, Icons.download, "Get token"),
      ],
    );

    Widget mediaTokenText = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        "There is some text that goes here",
        softWrap: true,
      ),
    );

    return MaterialApp(
      title: "Example App",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Layout Tutorial"),
        ),
        body: ListView(
          children: [
            titleSection,
            buttonRow,
            textSection,
            getMediaTokenData,
            mediaTokenText,
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildButtonRow(
      Color color, IconData icon, String buttonLabel) {
    return ElevatedButton(
      onPressed: () => onButtonRowPress(buttonLabel),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(buttonLabel),
        ],
      ),
    );
  }

  Future<void> onButtonRowPress(String label) async {
    if (label.toLowerCase() == "get token") {
      if (kDebugMode) print("Getting token...");

      LoginObject login = LoginObject(
          username: "joshl",
          password: "cheap-wrist-refined-BUILT-rafter-nutria-tedious-molar",
          serverURL: "https://jellyfin.joshl.duckdns.org");
      await login.getMediaToken();
      if (kDebugMode) print(login.mediaBrowser.token);
    } else
      print(label);
  }
}

void main() {
  runApp(
    const MaterialApp(title: "Jellytics", home: AppLayoutTutorial()),
  );
}
