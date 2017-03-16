import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:logging/logging.dart';

@Component(
    selector: 'selector',
    styles: const [],
    directives: const [materialDirectives],
    providers: const [materialProviders],
    template: '''
    Selector will go here
    ''')
class SelectorComponent  {
  static final Logger _log = new Logger("SelectorComponent");

  @Output()
  EventEmitter<IdNamePair> selectedItemChanged = new EventEmitter<IdNamePair>();

  @Input()
  IdNamePair selectedItem;

  @Input()
  List<IdNamePair> items = <IdNamePair>[];

  @Input()
  String label = "";


}
