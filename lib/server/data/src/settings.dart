import 'a_human_friendly_data.dart';
import 'dart:async';

class ImportSettings extends AData {
  String name;

  Map<String, String> fieldValues = new Map<String, String>();

  ImportSettings();

  Future validate() async {}
}
