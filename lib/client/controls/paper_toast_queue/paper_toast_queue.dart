// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('paper_toast_queue.html')
library dartalog.client.controls.paper_toast_queue;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';
import 'dart:collection';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_toast.dart';


/// A Polymer `<field-admin-page>` element.
@PolymerRegister('paper-toast-queue')
class PaperToastQueue extends PolymerElement  {
  static final Logger _log = new Logger("PaperToastQueue");

  PaperToastQueue.created() : super.created();

  @property
  int defaultDuration = 10000;

  @property
  int duration = 0;

  Queue messages = new Queue();

  PaperToast get toastElement => this.querySelector('paper-toast');

  @Property(notify: true)
  ToasterQueueMessage message;

  @reflectable
  closeToast(event, [_]) {
    toastElement.close();
    openNextMessage();
  }

  @reflectable
  toasterClicked(event, [_]) {
    set("duration",-1);
  }

  @reflectable
  toasterClosed(event, [_]) {
    openNextMessage();
  }

  void openNextMessage() {
    if(this.messages.length>0) {
      ToasterQueueMessage nextMessage = messages.removeFirst();

        if (nextMessage.severity == "error") {
          toastElement.classes.add("error");
        } else {
          toastElement.classes.remove("error");
        }

        set("message", nextMessage);
        set("duration", defaultDuration);
        toastElement.open();
    }
  }

  void enqueueMessage(String message, [String severity, String details]) {
    if(toastElement==null)
      return;

    ToasterQueueMessage newMessage = new ToasterQueueMessage(message, severity: severity, details: details);

    this.messages.add(newMessage);

    if (!toastElement.opened)
      openNextMessage();
  }
}

class ToasterQueueMessage extends JsProxy {
  @reflectable
  String message;
  @reflectable
  String severity;
  @reflectable
  String details;

  ToasterQueueMessage(this.message, {this.severity, this.details});
}