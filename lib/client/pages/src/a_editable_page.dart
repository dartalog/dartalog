import 'dart:async';
import 'package:polymer/polymer.dart';

abstract class AEditablePage {
  @Property(notify: true)
  bool showEditButton = true;

  Future edit();
}