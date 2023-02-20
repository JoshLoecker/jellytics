/// Create a function to print a string as a json object

import 'dart:convert';

void printAsJson(Map json) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(json);
  print(prettyprint);
}
