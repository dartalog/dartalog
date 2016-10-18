import 'dart:async';
import 'package:polymer/polymer.dart';

abstract class ASearchablePage {
  @Property(notify: true)
  bool showSearch = true;

  @Property(notify: true)
  String searchQuery = "";

  @reflectable
  Future<Null> search();
}
