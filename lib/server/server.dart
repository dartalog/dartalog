library server;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<Map> loadJSONFile(String path) async {
  File dir = new File(path);
  String contents = await dir.readAsString();
  Map output = JSON.decode(contents);
  return output;
}