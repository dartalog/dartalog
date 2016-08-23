library pages;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:dartalog/client/client.dart';
import 'package:polymer_elements/iron_input.dart';
import 'package:polymer_elements/paper_input_behavior.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:dartalog/client/controls/paper_toast_queue/paper_toast_queue.dart';
import 'package:dartalog/client/api/dartalog.dart';


import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/main_app.dart';
import 'package:dartalog/tools.dart';


part 'src/a_page.dart';
part 'src/a_refreshable_page.dart';
part 'src/a_searchable_page.dart';
part 'src/a_deletable_page.dart';
part 'src/a_editable_page.dart';
part 'src/a_saveable_page.dart';
part 'src/a_collection_page.dart';

class Pages {
  static const String ITEM_IMPORT = "item_impot";
  static const String ITEMS = "items";
}