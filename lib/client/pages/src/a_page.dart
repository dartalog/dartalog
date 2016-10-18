import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:dartalog/client/controls/controls.dart';

abstract class APage<T extends APage<T>> extends AControl {
  APage.created(this.title) : super.created();

  @Property(notify: true)
  String title;

  bool showBackButton = false;

  int lastScrollPosition = 0;

  void setTitle(String newTitle) {
    this.title = newTitle;
    set("title", newTitle);
    this.evaluatePage();
  }

  Future<Null> goBack() async {}

  bool evaluate(APage<T> page, bool evaluate(T page)) {
    if (page is T) {
      return evaluate(page);
    }
    return false;
  }
}
