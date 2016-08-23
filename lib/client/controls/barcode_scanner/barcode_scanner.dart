// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('barcode_scanner.html')
library dartalog.client.controls.barcode_Scanner;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/iron_image.dart';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;
import 'package:quagga_dart/quagga_dart.dart' as quagga;
import 'package:js/js.dart';

@PolymerRegister('barcode-scanner')
class BarcodeScannerControl extends AControl  {
  static final Logger _log = new Logger("BarcodeScannerControl ");

  Logger get loggerImpl => _log;


  BarcodeScannerControl.created() : super.created();

  Future<String> startBarcodeScanner() {
    Completer<String> completer = new Completer<String>();

    quagga.Constraints constraints = new quagga.Constraints(width: 640, height:480);
    quagga.InputStream inputStream = new quagga.InputStream(type: "LiveStream", constraints: constraints);
    quagga.Locator locator = new quagga.Locator(patchSize: "medium", halfSample: false);
    quagga.Decoder decoder = new quagga.Decoder(readers: ["code_128_reader"]);

    quagga.InitOption option = new quagga.InitOption(
        inputStream: inputStream, locator: locator, numOfWorkers: 4, locate: true, tracking: true, decoder: decoder);

    quagga.init(option, allowInteropCaptureThis((quagga.Error err) {
      try {
        if (err != null && err.message != null) {
          throw new Exception(err.message);
        }
        quagga.start();
      } catch (e,st) {
        completer.completeError(e,st);
      }
    }));

    quagga.onDetected(allowInterop((quagga.ResultData data) {
      completer.complete(data);
      quagga.stop();
    }));

    return completer.future;
  }
}