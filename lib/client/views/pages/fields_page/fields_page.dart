import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/api/api.dart' as api;
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/views/controls/common_controls.dart';
import 'package:dartalog/global.dart';
import 'package:logging/logging.dart';
import 'package:angular2/router.dart';
import '../src/a_page.dart';

@Component(
    selector: 'fields-page',
    directives: const [materialDirectives, commonControls],
    providers: const [materialProviders],
    styleUrls: const ["../../shared.css"],
    templateUrl: 'fields_page.html')
class FieldsPage extends APage implements OnInit, OnDestroy {
  static final Logger _log = new Logger("FieldsPage");

  @ViewChild("editForm")
  NgForm form;

  bool userAuthorized = false;

  List<IdNamePair> items = <IdNamePair>[];

  IdNamePair selectedItem;

  api.Field model = new api.Field();

  bool editVisible = false;

  @Output()
  EventEmitter<bool> visibleChange = new EventEmitter<bool>();

  StreamSubscription<PageActions> _pageActionSubscription;

  final PageControlService _pageControl;

  final ApiService _api;

  List<api.IdNamePair> users = <api.IdNamePair>[];

  FieldsPage(this._pageControl, this._api, AuthenticationService _auth, Router router)
      : super(_pageControl, _auth, router) {
    _pageControl.setPageTitle("Fields");
    _pageControl.setAvailablePageActions(
        <PageActions>[PageActions.Refresh, PageActions.Add]);
    _pageActionSubscription =
        _pageControl.pageActionRequested.listen(onPageActionRequested);
  }
  Map<String, String> get fieldTypes => globalFieldTypes;

  bool get isNewItem => selectedItem == null;

  @override
  Logger get loggerImpl => _log;

  bool get noItemsFound => items.isEmpty;

  void authorizationChanged(bool value) {
    this.userAuthorized = value;
    if (value) {
      refresh();
    } else {
      clear();
    }
  }

  void clear() {
    reset();
    items.clear();
  }

  @override
  void ngOnDestroy() {
    _pageActionSubscription.cancel();
    _pageControl.reset();
  }

  @override
  void ngOnInit() {
    //refresh();
  }

  void onPageActionRequested(PageActions action) {
    try {
      switch (action) {
        case PageActions.Refresh:
          this.refresh();
          break;
        case PageActions.Add:
          reset();
          editVisible = true;
          break;
        default:
          throw new Exception(
              action.toString() + " not implemented for this page");
      }
    } catch (e, st) {
      handleException(e, st);
    }
  }

  Future<Null> onSubmit() async {
    await performApiCall(() async {
      if (isNewItem) {
        await _api.fields.create(model);
      } else {
        await _api.fields.update(model, selectedItem.uuid);
      }
      editVisible = false;
      await this.refresh();
    }, form: form);
  }

  Future<Null> refresh() async {
    await performApiCall(() async {
      editVisible = false;
      items.clear();
      final ListOfIdNamePair data = await _api.fields.getAllIdsAndNames();
      items.addAll(data);
    });
  }

  void reset() {
    model = new api.Field();
    selectedItem = null;
    errorMessage = "";
  }

  Future<Null> selectItem(IdNamePair item) async {
    await performApiCall(() async {
      reset();
      model = await _api.fields.getById(item.uuid);
      selectedItem = item;
      editVisible = true;
    });
  }
}
