import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:dartalog/api/api.dart';
import 'package:dartalog/services/services.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:meta/meta.dart';

import 'a_page.dart';

abstract class AMaintenancePage<T> extends APage implements OnInit, OnDestroy {
  List<IdNamePair> items = <IdNamePair>[];
  List<IdNamePair> templates = <IdNamePair>[];

  IdNamePair selectedItem;
  IdNamePair selectedTemplate;

  dynamic model;

  StreamSubscription<PageActions> _pageActionSubscription;

  final PageControlService _pageControl;

  @protected
  final ApiService api;

  @ViewChild("editForm")
  NgForm form;

  bool _loadTemplates;

  bool showDeleteConfirmation = false;

  AMaintenancePage(this._loadTemplates, this._pageControl, this.api,
      AuthenticationService _auth, Router router)
      : super(_pageControl, _auth, router) {
    _pageControl.setAvailablePageActions(
        <PageActions>[PageActions.Refresh, PageActions.Add]);
    _pageActionSubscription =
        _pageControl.pageActionRequested.listen(onPageActionRequested);
    this.model = createBlank();
  }

  bool get isNewItem => StringTools.isNullOrWhitespace(model.uuid);

  dynamic get itemApi;

  bool get noItemsFound => items.isEmpty;

  void authorizationChanged(bool value) {
    this.userAuthorized = value;
    if (value) {
      refresh();
    } else {
      clear();
    }
  }

  void cancelEdit() {
    reset();
    for (int i = 0; i < items.length; i++) {
      if (StringTools.isNullOrWhitespace(items[i].uuid)) {
        items.removeAt(i);
        i--;
      }
    }
  }

  void clear() {
    reset();
    items.clear();
  }

  T createBlank();

  Future<Null> deleteClicked() async {
    showDeleteConfirmation = true;
  }

  Future<Null> deleteConfirmClicked() async {
    await performApiCall(() async {
      await itemApi.delete(selectedItem.uuid);
      await refresh();
    });
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
          cancelEdit();
          final IdNamePair id = new IdNamePair();
          id.name = "New Field";
          id.uuid = "";
          items.insert(0, id);
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
        await itemApi.create(model);
      } else {
        await itemApi.update(model, selectedItem.uuid);
      }
      await this.refresh();
    }, form: form);
  }

  Future<Null> refresh() async {
    await performApiCall(() async {
      final ListOfIdNamePair data = await itemApi.getAllIdsAndNames();
      items.clear();
      items.addAll(data);
      if (_loadTemplates) {
        final ListOfIdNamePair data = await itemApi.getAllTemplates();
        templates.clear();
        templates.addAll(data);
      }
      await refreshInternal();
    });
  }

  Future<Null> refreshInternal() async {}

  void reset() {
    model = createBlank();
    selectedItem = null;
    showDeleteConfirmation = false;
    errorMessage = "";
  }

  Future<Null> selectItem(IdNamePair item) async {
    await performApiCall(() async {
      reset();
      if (StringTools.isNotNullOrWhitespace(item.uuid))
        model = await itemApi.getByUuid(item.uuid);
      selectedItem = item;
      await selectItemInternal(item);
    });
  }

  Future<Null> selectItemInternal(IdNamePair item) async {}

  Future<Null> selectTemplate(IdNamePair template) async {
    await performApiCall(() async {
      final IdRequest request = new IdRequest();
      request.id = template.uuid;
      await itemApi.applyTemplate(request);
    }, after: () async {
      await refresh();
    });
  }
}
