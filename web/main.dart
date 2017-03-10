import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer/polymer.dart';
import 'package:angular2/platform/browser.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import "package:intl/intl_browser.dart";

import 'package:dartalog/client/views/main_app/main_app.dart';
import 'dart:async';
import 'package:logging/logging.dart';

main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(new LogPrintHandler());
  await findSystemLocale();

  await initPolymer();
  await bootstrap(MainApp);
}