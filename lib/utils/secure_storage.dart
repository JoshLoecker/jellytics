/*
This file implements flutter_secure_storage
*/
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> writeData() async {
  await storage.write(key: "username", value: "joshl");
}

Future<void> readData() async {
  print(await storage.read(key: "username"));
}
