import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:dartalog/client/controls/controls.dart';

abstract class APage<T extends APage> extends AControl {
  APage.created(this.title) : super.created();

  @Property(notify: true)
  String title;

  bool showBackButton = false;

  int lastScrollPosition = 0;

  @override
  Future activate([bool forceRefresh = false]) async {
    //notifyPath("route", this.route);
    await super.activate(forceRefresh);
  }

  @override
  Future activateInternal([bool forceRefresh = false]) async {
  }

    void setTitle(String newTitle) {
    this.title = newTitle;
    set("title", newTitle);
    this.evaluatePage();
  }

  Future goBack() {

  }

  bool evaluate(APage page, bool evaluate(T page)) {
    if(page is T) {
      return evaluate(page);
    }
    return false;
  }
}