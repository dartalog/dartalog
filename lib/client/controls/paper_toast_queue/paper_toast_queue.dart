// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('item_edit.html')
library dartalog.client.controls.paper_toast_queue;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_toast.dart';


/// A Polymer `<field-admin-page>` element.
@PolymerRegister('paper-toast-queue')
class PaperToastQueue extends PolymerElement  {
  static final Logger _log = new Logger("PaperToastQueue");

  PaperToastQueue.created() : super.created();

  PaperToast get toastElement => $['toaster'];

  @reflectable
  closeToast(event, [_]) async {
    toastElement.toggle();
  }
  void enqueueMessage(String message, [String severity]) {

    if (toastElement == null) return;

    if (toastElement.opened) toastElement.opened = false;

    new Timer(new Duration(milliseconds: 300), () {
      if (severity == "error") {
        toastElement.classes.add("error");
      } else {
        toastElement.classes.remove("error");
      }

      toastElement.text = "$message";
      toastElement.show();
    });
  }
}