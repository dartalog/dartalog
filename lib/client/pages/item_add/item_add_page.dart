// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_add_page.html")
library dartalog.client.pages.item_add_page;

import 'dart:async';
import 'dart:html';

import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/auth_wrapper/auth_wrapper_control.dart';
import 'package:dartalog/client/controls/item_edit/item_edit_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:web_components/web_components.dart';

/// A Polymer `<template-admin-page>` element.
@PolymerRegister('item-add-page')
class ItemAddPage extends APage with ASaveablePage {
  static final Logger _log = new Logger("ItemAddPage");

  ItemAddPage.created() : super.created("Add Item");

  AuthWrapperControl get authWrapper =>
      this.querySelector("auth-wrapper-control");

  ItemEditControl get itemEditControl =>
      this.querySelector('item-edit-control');

  Logger get loggerImpl => _log;

  attached() {
    super.attached();
    _loadPage();
  }

  _loadPage() async {
    await handleApiExceptions(() async {
      try {
        startLoading();
        bool authed = await authWrapper.evaluatePageAuthentication();
        this.showSaveButton = authed;
      } finally {
        stopLoading();
        this.evaluatePage();
      }
    });
  }

  @override
  Future save() async {
    String id = await itemEditControl.save();
    if (!StringTools.isNullOrWhitespace(id)) {
      showMessage("Item added");
      window.location.hash = "item/${id}";
    }
  }
}
