import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/cardWidget.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/utils/storage.dart' as storage;
import 'package:jellytics/providers/serverDetails.dart' as server;
import 'package:jellytics/utils/interface.dart';
import 'package:jellytics/models/movie.dart';
import 'package:jellytics/models/base.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Library(),
    );
  }
}

class Library extends ConsumerStatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  ConsumerState<Library> createState() => LibraryState();
}

class LibraryState extends ConsumerState<Library> {
  // late final Future<int> numLibraries;

  @override
  void initState() {
    super.initState();
  }

  Future<Widget> libraryListBuilder() async {
    // If not logged in, return loggedInStatusWidget
    if (!ref.watch(jellyFactory.notifier).isLoggedIn) {
      return loggedInStatusWidget(isLoggedIn: false);
    }

    final Map<String, dynamic> libraryJSON = await ref
        .watch(jellyFactory.notifier)
        .dio
        .get("/Items", queryParameters: {
      "userId": await storage.getUserID(),
    }).then((value) => value.data);

    // Map<String, dynamic> libraryJSON = await libraryList.data;
    return ListView(
      children: <Widget>[
        for (var i = 0; i < libraryJSON["TotalRecordCount"]; i++)
          cardContainer(
            InkWell(
              onTap: () {
                print("Tapped on ${libraryJSON['Items'][i]['Name']}");
                print(
                    "Network image: ${ref.watch(server.serverAddressProvider.notifier).fullAddress}/Items/${libraryJSON['Items'][i]['Id']}/Images/Primary");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                        "${ref.watch(server.serverAddressProvider.notifier).fullAddress}/Items/${libraryJSON['Items'][i]['Id']}/Images/Primary"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: libraryListBuilder(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text("No connection");
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return snapshot.data;
              }
          }
        });

    // Return an infinite scrolling list of numbers
    // return ListView.builder(
    //   // set itemCount
    //   itemCount: Future.value(numLibraries),
    //   itemBuilder: (context, index) {
    //     return const Text("Card");
    //   },
    // );
  }
}
