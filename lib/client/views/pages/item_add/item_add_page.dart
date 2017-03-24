import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/api/api.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/views/controls/common_controls.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:mime/mime.dart' as mime;
import 'item_edit_field.dart';
import '../src/a_page.dart';
import 'package:angular2/router.dart';

@Component(
    selector: 'item-add-page',
    directives: const [FORM_DIRECTIVES, materialDirectives, commonControls],
    providers: const [FORM_PROVIDERS, materialProviders],
    styleUrls: const ["../../shared.css"],
    templateUrl: 'item_add_page.html')
class ItemAddPage extends APage implements OnInit, OnDestroy {
  static final Logger _log = new Logger("ItemAddPage");

  bool userAuthorized = false;

  List<IdNamePair> itemTypes = <IdNamePair>[];

  List<IdNamePair> collections = <IdNamePair>[];
  List<ItemEditField> fields = <ItemEditField>[];
  String itemName = "";

  ItemType selectedItemType = new ItemType();
  String selectedItemTypeId = "";


  SearchResults importSearchResults = new SearchResults();

  bool importSearchBusy = false;

  String importSearchQuery = "";

  String selectedItemId = "";

  int currentTab = 0;

  StreamSubscription<PageActions> _pageActionSubscription;

  final PageControlService _pageControl;

  final ApiService _api;

  List<IdNamePair> users = <IdNamePair>[];

  ItemAddPage(this._pageControl, this._api, AuthenticationService _auth, Router router)
      : super(_pageControl, _auth, router) {
    _pageControl.setPageTitle("Add Item(s)");
    _pageControl.setAvailablePageActions(<PageActions>[PageActions.Refresh]);
    _pageActionSubscription =
        _pageControl.pageActionRequested.listen(onPageActionRequested);
  }

  Map<String, String> get fieldTypes => globalFieldTypes;

  @override
  Logger get loggerImpl => _log;

  bool get noCollectionsFound => collections.isEmpty;

  bool get noItemTypesFound => itemTypes.isEmpty;

  String selectedCollectionId = "";

  void authorizationChanged(bool value) {
    this.userAuthorized = value;
    if (value) {
      refresh();
    }
  }

  Future<Null> fileUploadChanged(dynamic event, String id) async {
    final Option<Element> parent = getParentElement(event.target, "div");
    if (parent.isEmpty) throw new Exception("Parent div not found");

    final int index = int.parse(parent.get().dataset["index"]);
    final ItemEditField field = this.fields[index];
    field.imageLoading = true;
    try {
      final InputElement input = event.target;
      if (input.files.length == 0) return;
      final File file = input.files[0];


      field.editImageUrl = file.name;

      final FileReader reader = new FileReader();
      reader.readAsArrayBuffer(file);
      await for (dynamic fileEvent in reader.onLoad) {
        try {
          field.mediaMessage = new MediaMessage();
          field.mediaMessage.bytes = reader.result;
          //List<String> parms = reader.result.toString().split(";");
          //field.mediaMessage.contentType = parms[0].split(":")[1];
          //field.mediaMessage.bytes = BASE64URL.decode(parms[1].split(",")[1]);

          field.mediaMessage.contentType = mime.lookupMimeType(file.name,
              headerBytes: field.mediaMessage.bytes.sublist(0, 10));

          final String value = new Uri.dataFromBytes(field.mediaMessage.bytes,
                  mimeType: field.mediaMessage.contentType)
              .toString();
          field.displayImageUrl = value;
        } finally {
          field.imageLoading = false  ;
        }
      }
    } finally {
      field.imageLoading = false;
    }
  }

  Future<Null> importSearch() async {
    await performApiCall(() async {
      importSearchBusy = true;
      try {
        if (StringTools.isNullOrWhitespace((importSearchQuery))) return;

        importSearchResults =
            await _api.import.search("amazon", importSearchQuery);
      } finally {
        importSearchBusy = false;
      }
    });
  }

  Future<Null> importSearchResult(SearchResult result) async {
    await performApiCall(() async {
      final ImportResult importResult =
          await _api.import.import("amazon", result.id);

      if (StringTools.isNotNullOrWhitespace(importResult.itemTypeId)) {
        selectedItemType = await _api.itemTypes
            .getById(importResult.itemTypeId, includeFields: true);
        selectedItemTypeId = importResult.itemTypeId;
      } else {
        selectedItemType = new ItemType();
        selectedItemTypeId="";
      }

      fields.clear();
      fields.addAll(ItemEditField.createList(selectedItemType.fields, importResult));

      itemName = ItemEditField.getImportResultValue(importResult, "name");

      currentTab = 2;
    });
  }

  @override
  void ngOnDestroy() {
    _pageActionSubscription.cancel();
    _pageControl.reset();
  }

  @override
  void ngOnInit() {
    refresh();
  }

  void onPageActionRequested(PageActions action) {
    try {
      switch (action) {
        case PageActions.Refresh:
          this.refresh();
          break;
        default:
          throw new Exception(
              action.toString() + " not implemented for this page");
      }
    } catch (e, st) {
      handleException(e, st);
    }
  }

  Future<Null> refresh() async {
    await performApiCall(() async {
      itemTypes.clear();
      final ListOfIdNamePair data = await _api.itemTypes.getAllIdsAndNames();
      itemTypes.addAll(data);
      collections.clear();
      collections.addAll(await _api.collections.getAllIdsAndNames());
    });
  }

  String newUniqueId = "";

  void reset() {
    importSearchResults = new SearchResults();
    importSearchQuery = "";

    selectedItemType = new ItemType();

    itemName = "";
    selectedItemTypeId="";
    fields.clear();
    selectedCollectionId = "";
    newUniqueId = "";

    errorMessage = "";
  }

  Future<Null> submitManualForm() async {
    await performApiCall(() async {
      final List<MediaMessage> files = new List<MediaMessage>();

      if (this.selectedItemType == null || this.selectedItemType.fields == null)
        throw new Exception("Please select an item type");

      final Item newItem = new Item();
      newItem.values = <String,String>{};

      for (ItemEditField f in this.fields) {
        if (f.type == "image") {
          if (f.mediaMessage != null) {
            files.add(f.mediaMessage);
            newItem.values[f.field.id] = "$fileUploadPrefix${files.length - 1}";
          }
        } else {
          newItem.values[f.field.id] = f.value;
        }
      }

      if (StringTools.isNotNullOrWhitespace(this.selectedItemId)) {
        final UpdateItemRequest request = new UpdateItemRequest();
        request.item = newItem;
        request.files = files;
        final IdResponse idResponse =
        await _api.items.updateItem(request, this.selectedItemId);
        return idResponse.id;
      } else {
        final CreateItemRequest request = new CreateItemRequest();
        request.item = newItem;
        request.uniqueId = newUniqueId;
        request.collectionId = selectedCollectionId;
        request.files = files;

        final ItemCopyId itemCopyId =
        await _api.items.createItemWithCopy(request);
        return itemCopyId.itemId;
      }
    });
  }



  void uploadClicked() {
//    final Option<Element> parent = getParentElement(event.target, "div");
//    if (parent.isEmpty) throw new Exception("Parent div not found");
//
//    final InputElement input = parent.get().querySelector("input[type='file']");
//    input.click();
  }
}
