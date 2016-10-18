import 'dart:async';
import 'package:polymer/polymer.dart';

abstract class ARefreshablePage {
  @Property(notify: true)
  bool showRefreshButton = true;

  @reflectable
  Future<Null> refresh();
}
