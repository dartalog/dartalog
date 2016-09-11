import 'dart:async';
import 'package:polymer/polymer.dart';
import 'a_page.dart';

abstract class ANestedPage<T extends APage> extends APage<T> {
  ANestedPage.created(String title) : super.created(title);

  @Property(notify: true)
  String title;

  bool showBackButton = false;

  int lastScrollPosition = 0;

  @Property(notify: true, observer: "routeChanged")
  Map get pageRoute => mainApp.pageRoute;

  @Property(notify: true)
  Map routeData;

  @Property(notify: true)
  Map routeParameters;


  void routeChanged(Object oldRoute, String newRoute) {
    mainApp.updatePageRoute(newRoute);
  }

  Future activate() async {
    notifyPath("pageRoute", this.pageRoute);
    await super.activate();
  }


  void setTitle(String newTitle) {
    this.title = newTitle;
    set("title", newTitle);
    this.evaluatePage();
  }

  Future goBack() {

  }

}