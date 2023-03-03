import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellytics/models/card_widget.dart';
import 'package:jellytics/client/client.dart';
import 'package:jellytics/utils/print.dart';
import 'package:jellytics/utils/storage.dart' as storage;
import 'package:jellytics/providers/server_details.dart';
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
  @override
  void initState() {
    super.initState();
    initClient(ref);
  }

  Future<Map<String, dynamic>> getLibraryJSON() async {
    if (!ref.watch(
        clientDetailsProvider.notifier.select((value) => value.isLoggedIn))) {
      return {};
    } else {}

    final Map<String, dynamic> libraryJSON =
        await ref.read(clientDetailsProvider.notifier).dio.get(
      "/Items",
      queryParameters: {
        "userId": ref.read(
          serverDetailsProvider.notifier.select(
            (value) => value.userId,
          ),
        ),
      },
    ).then((value) => value.data);
    return libraryJSON;
  }

  Future<Widget> libraryListBuilder() async {
    Map<String, dynamic> libraryJSON = await getLibraryJSON();
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
                        "${ref.read(
                          serverDetailsProvider.notifier.select(
                            (value) => value.fullAddress,
                          ),
                        )}/Items/${libraryJSON['Items'][index]['Id']}/Images/Primary",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget notLoggedIn() {
    return CupertinoPageScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          loggedInStatusWidget(isLoggedIn: false),
          if (kDebugMode)
            CupertinoButton(
              onPressed: () async {
                {
                  if (kDebugMode) {
                    print("");
                    print(
                        "Headers: ${ref.read(clientDetailsProvider.notifier.select((value) => value.dio.options.headers))}");
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
                }
              },
              child: const Text("Print SecureStorage"),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(serverDetailsProvider.notifier);
    ref.watch(clientDetailsProvider.notifier);

    FutureBuilder<Map<String, dynamic>> libraryJSON = FutureBuilder(
        future: getLibraryJSON(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.data;
        });

    if (!ref.watch(
        clientDetailsProvider.notifier.select((value) => value.isLoggedIn))) {
      return notLoggedIn();
    }
    return CupertinoPageScaffold(
      child: FutureBuilder(
        future: libraryListBuilder(),
        initialData: const Center(child: CupertinoActivityIndicator()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }
}
