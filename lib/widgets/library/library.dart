import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/cardWidget.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/utils/storage.dart' as storage;
import 'package:jellytics/providers/serverDetails.dart';
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

class LibraryState extends ConsumerState<Library> with clientFromStorage {
  // late final Future<int> numLibraries;

  @override
  void initState() {
    super.initState();
    initClient(ref);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.watch(clientDetailsProvider.notifier).clientFromStorage();
    // });
  }

  Future<Widget> libraryListBuilder() async {
    if (ref.read(clientDetailsProvider.notifier).dio.options.baseUrl == "") {
      ref.read(clientDetailsProvider.notifier).dio.options.baseUrl =
          ref.read(serverDetailsProvider.notifier).fullAddress;
    }

    final Map<String, dynamic> libraryJSON = await ref
        .read(clientDetailsProvider.notifier)
        .dio
        .get("/Items", queryParameters: {
      "userId": ref.read(serverDetailsProvider.notifier).userId,
    }).then((value) => value.data);

    return ListView.builder(
        itemCount: libraryJSON["TotalRecordCount"],
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return cardContainer(
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => LibraryDetail(
                        libraryName: libraryJSON["Items"][index]["Name"],
                        libraryId: libraryJSON["Items"][index]["Id"],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                          "${ref.read(serverDetailsProvider.notifier).fullAddress}/Items/${libraryJSON['Items'][index]['Id']}/Images/Primary"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(clientDetailsProvider.notifier).clientFromStorage();
    final server = ref.watch(serverDetailsProvider);
    final client = ref.watch(clientDetailsProvider);

    if (!ref.read(clientDetailsProvider.notifier).isLoggedIn) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          loggedInStatusWidget(isLoggedIn: false),
          if (kDebugMode)
            CupertinoButton(
              onPressed: () async {
                {
                  print("");
                  print(
                      "Headers: ${ref.read(clientDetailsProvider.notifier).dio.options.headers}");
                  print("Username: ${await storage.getUsername()}");
                  print("UserID: ${await storage.getUserId()}");
                  print("Protocol: ${await storage.getProtocol()}");
                  print("IP: ${await storage.getIP()}");
                  print("Port: ${await storage.getPort()}");
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
    } else {
      return FutureBuilder(
        future: libraryListBuilder(),
        initialData: const Center(child: CupertinoActivityIndicator()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text("No connection");
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Column(children: <Widget>[
                const Center(child: CupertinoActivityIndicator()),
                CupertinoButton(
                  onPressed: () async {
                    if (kDebugMode) {
                      print("");
                      print(
                          "Headers: ${ref.read(clientDetailsProvider.notifier).dio.options.headers}");
                      print("Username: ${await storage.getUsername()}");
                      print("UserID: ${await storage.getUserId()}");
                      print("Protocol: ${await storage.getProtocol()}");
                      print("IP: ${await storage.getIP()}");
                      print("Port: ${await storage.getPort()}");
                      print(
                          "Final Server Address: ${await storage.getFinalServerAddress()}");
                      print("Access Token: ${await storage.getAccessToken()}");
                      print("");
                    }
                  },
                  child: const Text("Print SecureStorage"),
                ),
              ]);
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
}
