import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/api/api.dart' as api;
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/views/controls/common_controls.dart';
import 'package:dartalog/global.dart';
import 'package:logging/logging.dart';

import '../src/a_page.dart';
import 'package:angular2/router.dart';

@Component(
    selector: 'item-types-page',
    directives: const [materialDirectives, commonControls],
    providers: const [materialProviders],
    styleUrls: const ["../../shared.css"],
    templateUrl: 'item_types_page.html')
class ItemTypesPage extends APage implements OnInit, OnDestroy {
  static final Logger _log = new Logger("ItemTypesPage");

  @ViewChild("editForm")
  NgForm form;

  bool userAuthorized = false;

  List<IdNamePair> items = <IdNamePair>[];

  List<api.IdNamePair> fields = <api.IdNamePair>[];

  IdNamePair selectedItem;
  IdNamePair selectedField;

  api.ItemType model = new api.ItemType();

  bool editVisible = false;

  @Output()
  EventEmitter<bool> visibleChange = new EventEmitter<bool>();

  StreamSubscription<PageActions> _pageActionSubscription;

  final PageControlService _pageControl;

  final ApiService _api;

  List<api.IdNamePair> users = <api.IdNamePair>[];

  ItemTypesPage(
      this._pageControl, this._api, AuthenticationService _auth, Router router)
      : super(_pageControl, _auth, router) {
    _pageControl.setPageTitle("Item Types");
    _pageControl.setAvailablePageActions(
        <PageActions>[PageActions.Refresh, PageActions.Add]);
    _pageActionSubscription =
        _pageControl.pageActionRequested.listen(onPageActionRequested);
  }

  void onReorder(ReorderEvent reorder) {
    model.fieldUuids.insert(
        reorder.destIndex, model.fieldUuids.removeAt(reorder.sourceIndex));
  }

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
          selectItem(null);
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
        await _api.itemTypes.create(model);
      } else {
        await _api.itemTypes.update(model, selectedItem.uuid);
      }
      editVisible = false;
      await this.refresh();
    }, form: form);
  }

  Future<Null> refresh() async {
    await performApiCall(() async {
      editVisible = false;
      items.clear();
      final ListOfIdNamePair data = await _api.itemTypes.getAllIdsAndNames();
      items.addAll(data);
    });
  }

  void reset() {
    model = new api.ItemType();
    selectedItem = null;
    selectedField = null;
    errorMessage = "";
  }

  Future<Null> selectItem(IdNamePair item) async {
    await performApiCall(() async {
      reset();
      if(item!=null) {
        model = await _api.itemTypes.getByUuid(item.uuid);
      }
      fields.clear();
      fields = await _api.fields.getAllIdsAndNames();
      selectedItem = item;
      editVisible = true;
    });
  }

  void removeField(String fieldUuid) {
    if (model != null && model.fieldUuids.contains(fieldUuid)) {
      model.fieldUuids.remove(fieldUuid);
    }
  }

  void addField() {
    if (selectedField != null && this.model != null) {
      if (this.model.fieldUuids == null) this.model.fieldUuids = <String>[];
      if (!this.model.fieldUuids.contains(selectedField.uuid)) {
        this.model.fieldUuids.add(selectedField.uuid);
      }
    }
  }
}
