import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/api/api.dart' as api;
import 'package:dartalog/services/services.dart';
import 'package:dartalog/views/controls/common_controls.dart';
import 'package:logging/logging.dart';
import '../src/a_maintenance_page.dart';
import 'package:dartalog/data/data.dart';

@Component(
    selector: 'item-types-page',
    directives: const [materialDirectives, commonControls],
    providers: const [materialProviders],
    styleUrls: const ["../../shared.css"],
    templateUrl: 'item_types_page.html')
class ItemTypesPage extends AMaintenancePage<api.ItemType> {
  static final Logger _log = new Logger("ItemTypesPage");

  UuidCollection<api.IdNamePair> fields = new UuidCollection<api.IdNamePair>();

  IdNamePair selectedField;

  ItemTypesPage(PageControlService pageControl, ApiService api,
      AuthenticationService auth, Router router)
      : super(true, pageControl, api, auth, router) {
    pageControl.setPageTitle("Item Types");
  }

  @override
  dynamic get itemApi => this.api.itemTypes;

  @override
  Logger get loggerImpl => _log;

  void addField() {
    if (selectedField != null && this.model != null) {
      if (this.model.fieldUuids == null) this.model.fieldUuids = <String>[];
      if (!this.model.fieldUuids.contains(selectedField.uuid)) {
        this.model.fieldUuids.add(selectedField.uuid);
      }
    }
  }

  @override
  api.ItemType createBlank() {
    final api.ItemType output = new api.ItemType();
    output.fieldUuids = <String>[];
    return output;
  }

  void onReorder(ReorderEvent reorder) {
    model.fieldUuids.insert(
        reorder.destIndex, model.fieldUuids.removeAt(reorder.sourceIndex));
  }

  void removeField(String fieldUuid) {
    if (model != null && model.fieldUuids.contains(fieldUuid)) {
      model.fieldUuids.remove(fieldUuid);
    }
  }

  @override
  void reset() {
    super.reset();
    selectedField = null;
  }

  @override
  Future<Null> selectItemInternal(IdNamePair item) async {
    final api.ListOfIdNamePair data = await this.api.fields.getAllIdsAndNames();
    fields.clear();
    fields.addAllItems(data);
  }
}
