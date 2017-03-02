// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('curator_tools_page.html')
library dartalog.client.pages.curator_tools_page;

import 'dart:async';
import 'dart:html';

import 'package:dartalog/client/api/api.dart' as api;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/auth_wrapper/auth_wrapper_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/controls/item_picker/item_picker_control.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:web_components/web_components.dart';

/// A Polymer `<field-admin-page>` element.
@PolymerRegister('curator-tools-page')
class CuratorToolsPage extends APage with ACollectionPage {
  static final Logger _log = new Logger("CuratorToolsPage");

  @property
  List<IdNamePair> collections = new List<IdNamePair>();

  @property
  String targetCollectionId;

  @Property(notify: true)
  String errorMessage = "";

  @property
  bool userHasAccess = false;
  /// Constructor used to create instance of MainApp.
  CuratorToolsPage.created() : super.created("Curator Tools");

  AuthWrapperControl get authWrapper =>
      this.querySelector("auth-wrapper-control");

  @override
  Logger get loggerImpl => _log;

  @override
  void attached() {
    super.attached();
    refresh();
  }

  @override
  @reflectable
  Future<Null> refresh() async {
    await handleApiExceptions(() async {
      startLoading();
      try {
        final bool authed = await authWrapper.evaluatePageAuthentication();
        this.showRefreshButton = authed;
        if (!authed) return;

        this.reset();
        clear("collections");

        final api.ListOfIdNamePair data =
            await api.item.collections.getAllIdsAndNames();

        addAll("collections", IdNamePair.copyList(data));
      } finally {
        stopLoading();
        this.evaluatePage();
      }
    });
  }

  @reflectable
  void reset() {
    clearValidation();
    set('currentCollection', new Collection());
  }


  @override
  void setGeneralErrorMessage(String message) => set("errorMessage", message);

  @reflectable
  Future<Null> itemFound(CustomEventWrapper event, ItemCopy itemCopy) async {
    await handleApiExceptions(() async {
      if(StringTools.isNullOrWhitespace(targetCollectionId)) {
        throw new Exception("Target collection is required");
      }
      final api.TransferRequest request = new api.TransferRequest();
      request.targetCollection = targetCollectionId;
      final api.ItemCopyId id = new api.ItemCopyId();
      id.itemId = itemCopy.itemId;
      id.copy = itemCopy.copy;
      request.itemCopies = <api.ItemCopyId>[];
      request.itemCopies.add(id);


      await api.item.items.copies.transfer(request);
      showMessage("Item transfered ");

    });
  }

  @reflectable
  void validateField(event, [_]) {
    _log.info("Validating");
  }
}
