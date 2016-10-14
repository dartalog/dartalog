// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('image_zoomer.html')
library dartalog.client.controls.image_zoomer;

import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/iron_image.dart';
import 'package:dartalog/client/controls/controls.dart';

@PolymerRegister('image-zoomer')
class ImageZoomerControl extends AControl  {
  static final Logger _log = new Logger("ImageZoomerControl ");

  Logger get loggerImpl => _log;

  @Property(notify: true)
  String src;

  @Property(notify: true)
  String fullsize;

  @Property(notify: true)
  String title;

  ImageZoomerControl.created() : super.created();

  @reflectable
  void closeFullsize(event, [_]) {
    IronImage ele = this.querySelector("iron-image");
    ele.style.display = "none";

  }

  @reflectable
  void showFullsize(event, [_]) {
    try {
      event.preventDefault();
    IronImage ele = this.querySelector("iron-image");
    ele.preventLoad = false;

    ele.style.display = "block";

    } catch(e,st) {
      this.handleException(e,st);
    }
  }
}