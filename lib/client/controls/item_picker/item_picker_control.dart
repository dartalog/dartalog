// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('item_picker_control.html')
library dartalog.client.controls.item_picker;

import 'dart:async';
import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';
import 'package:dartalog/client/api/api.dart' as api;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';

@PolymerRegister('item-picker-control')
class ItemPickerControl extends AControl {
  static final Logger _log = new Logger("ItemPickerControl");

  @property
  String itemId;

  ItemPickerControl.created() : super.created();

  @property
  String buttonText = "Search";

  @reflectable
  Future<Null> searchKeypress(event, [_]) async {
    if (event.original.charCode == 13)
      await searchClicked(event);
  }


  @reflectable
  Future<Null> searchClicked(event, [_]) async {
    await handleApiExceptions(() async {
      if(StringTools.isNullOrWhitespace(itemId))
        return;
      final ItemCopy copy = new ItemCopy.copyFrom(await api.item.items.copies.getByUniqueID(itemId));
      this.fire("item-found", detail: copy);
      set("itemId","");
    });
  }


}