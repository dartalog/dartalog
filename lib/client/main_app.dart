// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('main_app.html')
library dartalog.client.main_app;

import 'dart:html';
import 'dart:async';
import 'package:http/browser_client.dart' as http;
import 'package:route_hierarchical/client.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/browser_logging_handlers.dart';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer/polymer.dart';

import 'package:web_components/web_components.dart';

import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/iron_icons.dart';

import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/api/dartalog.dart';
import 'package:dartalog/client/controls/paper_toast_queue/paper_toast_queue.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/pages/item_browse/item_browse_page.dart';
import 'package:dartalog/client/pages/item_add/item_add_page.dart';
import 'package:dartalog/client/pages/item/item_page.dart';
import 'package:dartalog/client/pages/field_admin/field_admin_page.dart';
import 'package:dartalog/client/pages/item_type_admin/item_type_admin_page.dart';


/// Uses [PaperInput]
@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  @property String visiblePage = "item_browse";

  @property bool showRefresh = false;
  @property bool showSearch= false;
  @property bool showAdd = false;
  @property bool showEdit = false;
  @property bool showDelete = false;

  @property bool showBack = false;

  final Router router = new Router(useFragment: true);

  final DartalogApi api = new DartalogApi(new http.BrowserClient(), rootUrl: "http://localhost:3278/", servicePath: "api/dartalog/0.1/");

  @Property(notify: true)
  APage currentPage = null;

  PaperDrawerPanel get drawerPanel => $["drawerPanel"];

  FieldAdminPage get fieldAdmin=> $['field_admin'];
  ItemTypeAdminPage get itemTypeAdmin=> $['item_type_admin'];
//  TemplateAdminPage get templateAdmin=> $['item_type_admin'];
  ItemAddPage get itemAddAdmin=> $['item_add'];
//  ItemBrowsePage get itemBrowse=> $['browse'];
//  ItemPage get itemPage=> $['item'];



  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler());

    // Set up the routes for all the pages.

    router.root

    ..addRoute(
        name: BROWSE_ROUTE_NAME,
        path: "items",
        defaultRoute: true,
        enter: enterRoute,
        mount: (router) => router.addRoute(
          name: ITEM_VIEW_ROUTE_NAME,
          path: "/:${ITEM_VIEW_ROUTE_ARG_ITEM_ID_NAME}",
          defaultRoute: false,
          enter: enterRoute)
    )
    ..addRoute(
        name: "item_add",
        path: "new",
        defaultRoute: false,
        enter: enterRoute)
    ..addRoute(
        name: "field_admin",
        path: "fields",
        defaultRoute: false,
        enter: enterRoute)
      ..addRoute(
          name: "item_type_admin",
          path: "item_types",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "logging_output",
          path: "logging_output",
          defaultRoute: false,
          enter: enterRoute);

    router.listen();
  }

  @reflectable
  drawerItemClicked(event, [_]) async {
    Element ele = getParentElement(event.target, "paper-item");
    if(ele!=null) {
      String route = ele.dataset["route"];
      activateRoute(route);
    }
  }

  activateRoute(String route, {Map<String,String> arguments}) {
    if(arguments==null)
      arguments = new Map<String,String>();
    router.go(route,arguments);
  }


  void routeChanged() {
    if (visiblePage is! String) return;
    router.go("field_admin", {});
  }

  Future enterRoute(RouteEvent e) async {
    try {
      set("visiblePage", e.route.name);

      set("showBack", (router.activePath.length>1));

      dynamic page = $[e.route.name];

      if (page == null) {
        throw new Exception("Page not found: ${this.visiblePage}");
      }

      if(!(page is APage)) {
        throw new Exception("Unknown element type: ${page.runtimeType.toString()}");
      }

      set("currentPage", page);
      evaluatePage();
      await this.currentPage.activate(this.api, e.parameters);
    } catch(e,st) {
      window.alert(e.toString());
    }
  }

  void handleException(e, st) {
    showMessage(e.toString(), "error");
  }

  void showMessage(String message, [String severity]) {
    PaperToastQueue toastElement = $['global_toast'];
    if(toastElement!=null)
      toastElement.enqueueMessage(message, severity);
  }

  void evaluatePage() {
    set("currentPage.title", currentPage.title);

    //set("showBack", currentPage.showBackButton);

    set("showRefresh", currentPage is ARefreshablePage);

    set("showAdd", currentPage is ACollectionPage);

    set("showSearch", currentPage is ASearchablePage);

    set("showDelete", currentPage is ADeletablePage);

    set("showEdit", currentPage is AEditablePage);
  }

  @reflectable
  refreshClicked(event, [_]) async {
    if (currentPage is ARefreshablePage) {
      dynamic page = currentPage;
      page.refresh();
    }
  }

  @reflectable
  addClicked(event, [_]) async {
    if (currentPage is ACollectionPage) {
      ACollectionPage page = currentPage as ACollectionPage;
      page.newItem();
    }
  }


  @reflectable
  deleteClicked(event, [_]) async {
    if (currentPage is ADeletablePage) {
      dynamic page = currentPage;
      page.delete();
    }
  }


  @reflectable
  backClicked(event, [_]) async {
    if(router.activePath.length==1)
      return;
    Route r = router.activePath[router.activePath.length-2];

    router.go(r.name, r.parameters);
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
//    super.attributeChanged(name, oldValue, newValue);
//  }

//  /// Called when main-app has been fully prepared (Shadow DOM created,
//  /// property observers set up, event listeners attached).
//  ready() {
//  }
}

class Employee extends JsProxy {
  @reflectable
  String first;

  @reflectable
  String last;

  Employee(this.first, this.last);
}