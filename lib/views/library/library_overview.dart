import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellytics/utils/screens.dart';
import 'package:jellytics/views/library/get_library.dart';
import 'package:jellytics/views/library/library_details.dart';

class _LibraryOverview extends StatefulWidget {
  const _LibraryOverview();

  @override
  State<_LibraryOverview> createState() => _LibraryOverviewState();
}

class _LibraryOverviewState extends State<_LibraryOverview> {
  Widget libraryCard({
    required SpecificLibraryInfo libraryData,
    double maxCardHeight = 125,
  }) {
    Widget child = InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LibraryDetails(libraryData: libraryData)),
        );
      },
      child: defaultCard(
        context: context,
        containerChild: Container(
          alignment: Alignment.center,
          child: Text(libraryData.libraryName),
        ),
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints.expand(
        width: safeWidth(context),
        height: maxCardHeight,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // In debug mode!
    if (kDebugMode) {
      // Use a GridView.list
      return FutureBuilder(
          future: getUserLibraries(),
          builder: (context, AsyncSnapshot<List<SpecificLibraryInfo>> futures) {
            if (futures.hasData) {
              return ListView.builder(
                itemCount: futures.data?.length,
                itemBuilder: (context, index) {
                  return libraryCard(
                    libraryData: futures.data![index],
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });

      // In production mode!
    } else {
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
}

const Widget libraryContent = _LibraryOverview();
