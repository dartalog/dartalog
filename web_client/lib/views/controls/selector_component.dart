import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/services/services.dart';
import 'package:logging/logging.dart';
import 'package:dartalog/api/api.dart';

@Component(
    selector: 'selector',
    styles: const [],
    directives: const [materialDirectives],
    providers: const [materialProviders],
    template: '''
    <material-input [(ngModel)]="userName" [ngControl]="ngControl" floatingLabel [label]="label"></material-input>
    ''')
class SelectorComponent extends BaseMaterialInput {
  static final Logger _log = new Logger("SelectorComponent");

  @Output()
  EventEmitter<IdNamePair> selectedItemChanged = new EventEmitter<IdNamePair>();

  @Input()
  IdNamePair selectedItem;

  @Input()
  List<IdNamePair> items = <IdNamePair>[];

  SelectorComponent(@Self() @Optional() NgControl cd,
      ChangeDetectorRef changeDetector, DeferredValidator validator)
      : super(cd, changeDetector, validator);
}
