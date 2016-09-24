// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_page.html")
library dartalog.client.pages.item_page;

import 'dart:async';

import 'package:dartalog/client/pages/pages.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:dartalog/client/pages/item/view/item_view.dart';
import 'package:dartalog/tools.dart';

@PolymerRegister('item-page')
class ItemPage extends APage with AEditablePage {
  static final Logger _log = new Logger("ItemPage");

  @Property(notify: true)
  bool editPageActive = false;

  @Property(notify: true)
  Map editPageRoute;

  ItemPage.created() : super.created("Item") {
    this.showBackButton = true;
  }

  ItemViewPage get itemViewPage =>this.querySelector("#itemViewPage");

  Logger get loggerImpl => _log;

@override
String get title {
  if(editPageActive)
    return EMPTY_STRING;
  else
    return itemViewPage.title;
}

  @override
  String get editLink {
    if(editPageActive)
      return EMPTY_STRING;

    return itemViewPage.editLink;
  }

}
