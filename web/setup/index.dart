// Copyright (c) 2016, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:dartalog/client/main_app.dart';
import 'package:polymer/polymer.dart';

/// [MainApp] used!
Future<Null> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(new LogPrintHandler());
  await initPolymer();
}
