import 'dart:convert';
import 'package:flutter/foundation.dart';

void prettyPrintJSON(Map<String, dynamic> data, JsonEncoder? encoder) {
  // Define a new encoder if "encoder" is null (i.e., not provided)
  // From: https://dart.dev/guides/language/language-tour#assignment-operators
  encoder ??= const JsonEncoder.withIndent("  ");
  if (kDebugMode) {
    print(encoder.convert(data));
  }
}

void prettyPrintJSONList(List<dynamic> data) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  for (var i = 0; i < data.length; i++) {
    if (data[i] is Map) {
      prettyPrintJSON(data[i], encoder);
    }
  }
}
