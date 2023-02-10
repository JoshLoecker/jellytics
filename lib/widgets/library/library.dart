import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/cardWidget.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/utils/storage.dart' as storage;
import 'package:jellytics/providers/serverDetails.dart' as server;
import 'package:jellytics/utils/interface.dart';
import 'package:jellytics/widgets/library/library_detail.dart';

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

  Future<Widget> libraryListBuilder(bool isLoggedIn) async {
    // If not logged in, return loggedInStatusWidget
    if (!isLoggedIn) {
      Widget col = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          loggedInStatusWidget(isLoggedIn: false),
          CupertinoButton(
            onPressed: () async {
              {
                print("");
                print(
                    "Headers: ${ref.watch(jellyFactory.notifier).dio.options.headers}");
                print("Username: ${await storage.getUsername()}");
                print("UserID: ${await storage.getUserID()}");
                print("Protocol: ${await storage.getServerProtocol()}");
                print("IP: ${await storage.getServerIP()}");
                print("Port: ${await storage.getServerPort()}");
                print(
                    "Final Server Address: ${await storage.getFinalServerAddress()}");
                print("Access Token: ${await storage.getAccessToken()}");
                print("");
              }
            },
            child: const Text("Print SecureStorage"),
          ),
        ],
      );
      return col;
    }

    String serverAddress =
        ref.watch(server.serverAddressProvider.notifier).fullAddress;

    final Map<String, dynamic> libraryJSON = await ref
        .watch(jellyFactory.notifier)
        .dio
        .get("/Items", queryParameters: {
      "userId": ref.watch(server.serverAddressProvider.notifier).userId,
    }).then((value) => value.data);

    return ListView(
      children: <Widget>[
        for (var i = 0; i < libraryJSON["TotalRecordCount"]; i++)
          cardContainer(
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => LibraryDetail(
                        libraryName: libraryJSON["Items"][i]["Name"],
                        libraryId: libraryJSON["Items"][i]["Id"],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                          "$serverAddress/Items/${libraryJSON['Items'][i]['Id']}/Images/Primary"),
                      fit: BoxFit.cover,
                    ),
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
    bool isLoggedIn = ref.watch(jellyFactory.notifier).isLoggedIn;

    return FutureBuilder(
      future: libraryListBuilder(isLoggedIn),
      initialData: const Center(child: CupertinoActivityIndicator()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("No connection");
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CupertinoActivityIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return snapshot.data;
            }
        }
      },
    );
  }
}
