// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport('main_app.html')
library dartalog.client.main_app;

import 'dart:html';
import 'package:http/browser_client.dart' as http;

import 'package:logging/logging.dart';
import 'package:logging_handlers/browser_logging_handlers.dart';
import 'package:route_hierarchical/client.dart';

import 'package:polymer/polymer.dart';
import 'package:core_elements/core_scaffold.dart';
import 'package:core_elements/core_pages.dart';
import 'package:core_elements/core_toolbar.dart';
import 'package:core_elements/core_icon.dart';
import 'package:core_elements/core_animated_pages.dart';
import 'package:core_elements/core_animated_pages/transitions/slide_from_right.dart';
import 'package:paper_elements/paper_item.dart';
import 'package:paper_elements/paper_icon_button.dart';
import 'package:paper_elements/paper_input.dart';
import 'package:paper_elements/paper_progress.dart';

import 'api/dartalog.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/pages/item_browse/item_browse_page.dart';
import 'package:dartalog/client/pages/item_add/item_add_page.dart';
import 'package:dartalog/client/pages/field_admin/field_admin_page.dart';
import 'package:dartalog/client/pages/template_admin/template_admin_page.dart';

/// A Polymer `<main-app>` element.
@CustomTag('main-app')
class MainApp extends PolymerElement {
  @observable String reversed = '';

  @observable String visiblePageTitle = "Field Admin";
  @observable String visiblePage = "field_admin";
  @observable bool visiblePageRefreshable = false;

  final Router router = new Router(useFragment: true);

  CoreScaffold get scaffold => $['scaffold'];

  final DartalogApi api = new DartalogApi(new http.BrowserClient(), rootUrl: "http://localhost:8888/", servicePath: "api/dartalog/0.1/");

  APage get currentPage => $[visiblePage];
  FieldAdminPage get fieldAdmin=> $['field_admin'];
  TemplateAdminPage get templateAdmin=> $['template_admin'];
  ItemAddPage get itemAddAdmin=> $['item_add'];
  ItemBrowsePage get itemBrowseAdmin=> $['item_browse'];

  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created();

  domReady() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler());

    // Set up the routes for all the pages.
    router.root.addRoute(
        name: "Item Browse", path: "item_browse",
        defaultRoute: false,
        enter: enterRoute);
    router.root.addRoute(
        name: "Item Add", path: "item_add",
        defaultRoute: true,
        enter: enterRoute);
    router.root.addRoute(
        name: "Field Admin", path: "field_admin",
        defaultRoute: false,
        enter: enterRoute);
    router.root.addRoute(
        name: "Template Admin", path: "template_admin",
        defaultRoute: false,
        enter: enterRoute);

    router.listen();

    this.fieldAdmin.init(this.api);
    this.templateAdmin.init(this.api);
    this.itemAddAdmin.init(this.api);
    this.itemBrowseAdmin.init(this.api);
  }

  void routeChanged() {
    if (visiblePage is! String) return;
    router.go("field_admin", {});
  }

  void enterRoute(RouteEvent e) {
    visiblePage = e.path;
    this.visiblePageTitle = e.route.name;

    if(currentPage is ARefreshablePage) {
      this.visiblePageRefreshable = true;
      (currentPage as ARefreshablePage).refresh();
    } else {
      this.visiblePageRefreshable = false;
    }
  }

  refreshClicked(event, detail, target) async {
    if(currentPage is ARefreshablePage) {
      dynamic page = currentPage;
      page.refresh();
    }
  }
  // Optional lifecycle methods - uncomment if needed.

//  /// Called when an instance of main-app is inserted into the DOM.
//  attached() {
//    super.attached();
//  }

//  /// Called when an instance of main-app is removed from the DOM.
//  detached() {
//    super.detached();
//  }

//  /// Called when an attribute (such as a class) of an instance of
//  /// main-app is added, changed, or removed.
//  attributeChanged(String name, String oldValue, String newValue) {
//    super.attributeChanges(name, oldValue, newValue);
//  }

//  /// Called when main-app has been fully prepared (Shadow DOM created,
//  /// property observers set up, event listeners attached).
//  ready() {
//    super.ready();
//  }
}
