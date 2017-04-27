library api_client.item.D0_1.test;

import "dart:core" as core;
import "dart:collection" as collection;
import "dart:async" as async;
import "dart:convert" as convert;

import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:unittest/unittest.dart' as unittest;

import 'package:api_client/item/0_1.dart' as api;

class HttpServerMock extends http.BaseClient {
  core.Function _callback;
  core.bool _expectJson;

  void register(core.Function callback, core.bool expectJson) {
    _callback = callback;
    _expectJson = expectJson;
  }

  async.Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (_expectJson) {
      return request.finalize()
          .transform(convert.UTF8.decoder)
          .join('')
          .then((core.String jsonString) {
        if (jsonString.isEmpty) {
          return _callback(request, null);
        } else {
          return _callback(request, convert.JSON.decode(jsonString));
        }
      });
    } else {
      var stream = request.finalize();
      if (stream == null) {
        return _callback(request, []);
      } else {
        return stream.toBytes().then((data) {
          return _callback(request, data);
        });
      }
    }
  }
}

http.StreamedResponse stringResponse(
    core.int status, core.Map headers, core.String body) {
  var stream = new async.Stream.fromIterable([convert.UTF8.encode(body)]);
  return new http.StreamedResponse(stream, status, headers: headers);
}

buildUnnamed0() {
  var o = new core.List<core.String>();
  o.add("foo");
  o.add("foo");
  return o;
}

checkUnnamed0(core.List<core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o[0], unittest.equals('foo'));
  unittest.expect(o[1], unittest.equals('foo'));
}

core.int buildCounterBulkItemActionRequest = 0;
buildBulkItemActionRequest() {
  var o = new api.BulkItemActionRequest();
  buildCounterBulkItemActionRequest++;
  if (buildCounterBulkItemActionRequest < 3) {
    o.action = "foo";
    o.actionerUserUuid = "foo";
    o.itemCopyUuids = buildUnnamed0();
  }
  buildCounterBulkItemActionRequest--;
  return o;
}

checkBulkItemActionRequest(api.BulkItemActionRequest o) {
  buildCounterBulkItemActionRequest++;
  if (buildCounterBulkItemActionRequest < 3) {
    unittest.expect(o.action, unittest.equals('foo'));
    unittest.expect(o.actionerUserUuid, unittest.equals('foo'));
    checkUnnamed0(o.itemCopyUuids);
  }
  buildCounterBulkItemActionRequest--;
}

buildUnnamed1() {
  var o = new core.List<core.String>();
  o.add("foo");
  o.add("foo");
  return o;
}

checkUnnamed1(core.List<core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o[0], unittest.equals('foo'));
  unittest.expect(o[1], unittest.equals('foo'));
}

buildUnnamed2() {
  var o = new core.List<core.String>();
  o.add("foo");
  o.add("foo");
  return o;
}

checkUnnamed2(core.List<core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o[0], unittest.equals('foo'));
  unittest.expect(o[1], unittest.equals('foo'));
}

core.int buildCounterCollection = 0;
buildCollection() {
  var o = new api.Collection();
  buildCounterCollection++;
  if (buildCounterCollection < 3) {
    o.browserUuids = buildUnnamed1();
    o.curatorUuids = buildUnnamed2();
    o.name = "foo";
    o.publiclyBrowsable = true;
    o.readableId = "foo";
    o.uuid = "foo";
  }
  buildCounterCollection--;
  return o;
}

checkCollection(api.Collection o) {
  buildCounterCollection++;
  if (buildCounterCollection < 3) {
    checkUnnamed1(o.browserUuids);
    checkUnnamed2(o.curatorUuids);
    unittest.expect(o.name, unittest.equals('foo'));
    unittest.expect(o.publiclyBrowsable, unittest.isTrue);
    unittest.expect(o.readableId, unittest.equals('foo'));
    unittest.expect(o.uuid, unittest.equals('foo'));
  }
  buildCounterCollection--;
}

buildUnnamed3() {
  var o = new core.List<api.MediaMessage>();
  o.add(buildMediaMessage());
  o.add(buildMediaMessage());
  return o;
}

checkUnnamed3(core.List<api.MediaMessage> o) {
  unittest.expect(o, unittest.hasLength(2));
  checkMediaMessage(o[0]);
  checkMediaMessage(o[1]);
}

core.int buildCounterCreateItemRequest = 0;
buildCreateItemRequest() {
  var o = new api.CreateItemRequest();
  buildCounterCreateItemRequest++;
  if (buildCounterCreateItemRequest < 3) {
    o.collectionUuid = "foo";
    o.files = buildUnnamed3();
    o.item = buildItem();
    o.uniqueId = "foo";
  }
  buildCounterCreateItemRequest--;
  return o;
}

checkCreateItemRequest(api.CreateItemRequest o) {
  buildCounterCreateItemRequest++;
  if (buildCounterCreateItemRequest < 3) {
    unittest.expect(o.collectionUuid, unittest.equals('foo'));
    checkUnnamed3(o.files);
    checkItem(o.item);
    unittest.expect(o.uniqueId, unittest.equals('foo'));
  }
  buildCounterCreateItemRequest--;
}

core.int buildCounterField = 0;
buildField() {
  var o = new api.Field();
  buildCounterField++;
  if (buildCounterField < 3) {
    o.format = "foo";
    o.name = "foo";
    o.readableId = "foo";
    o.type = "foo";
    o.unique = true;
    o.uuid = "foo";
  }
  buildCounterField--;
  return o;
}

checkField(api.Field o) {
  buildCounterField++;
  if (buildCounterField < 3) {
    unittest.expect(o.format, unittest.equals('foo'));
    unittest.expect(o.name, unittest.equals('foo'));
    unittest.expect(o.readableId, unittest.equals('foo'));
    unittest.expect(o.type, unittest.equals('foo'));
    unittest.expect(o.unique, unittest.isTrue);
    unittest.expect(o.uuid, unittest.equals('foo'));
  }
  buildCounterField--;
}

core.int buildCounterIdNamePair = 0;
buildIdNamePair() {
  var o = new api.IdNamePair();
  buildCounterIdNamePair++;
  if (buildCounterIdNamePair < 3) {
    o.name = "foo";
    o.readableId = "foo";
    o.uuid = "foo";
  }
  buildCounterIdNamePair--;
  return o;
}

checkIdNamePair(api.IdNamePair o) {
  buildCounterIdNamePair++;
  if (buildCounterIdNamePair < 3) {
    unittest.expect(o.name, unittest.equals('foo'));
    unittest.expect(o.readableId, unittest.equals('foo'));
    unittest.expect(o.uuid, unittest.equals('foo'));
  }
  buildCounterIdNamePair--;
}

core.int buildCounterIdRequest = 0;
buildIdRequest() {
  var o = new api.IdRequest();
  buildCounterIdRequest++;
  if (buildCounterIdRequest < 3) {
    o.id = "foo";
  }
  buildCounterIdRequest--;
  return o;
}

checkIdRequest(api.IdRequest o) {
  buildCounterIdRequest++;
  if (buildCounterIdRequest < 3) {
    unittest.expect(o.id, unittest.equals('foo'));
  }
  buildCounterIdRequest--;
}

core.int buildCounterIdResponse = 0;
buildIdResponse() {
  var o = new api.IdResponse();
  buildCounterIdResponse++;
  if (buildCounterIdResponse < 3) {
    o.location = "foo";
    o.uuid = "foo";
  }
  buildCounterIdResponse--;
  return o;
}

checkIdResponse(api.IdResponse o) {
  buildCounterIdResponse++;
  if (buildCounterIdResponse < 3) {
    unittest.expect(o.location, unittest.equals('foo'));
    unittest.expect(o.uuid, unittest.equals('foo'));
  }
  buildCounterIdResponse--;
}

buildUnnamed4() {
  var o = new core.List<core.String>();
  o.add("foo");
  o.add("foo");
  return o;
}

checkUnnamed4(core.List<core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o[0], unittest.equals('foo'));
  unittest.expect(o[1], unittest.equals('foo'));
}

buildUnnamed5() {
  var o = new core.Map<core.String, core.List<core.String>>();
  o["x"] = buildUnnamed4();
  o["y"] = buildUnnamed4();
  return o;
}

checkUnnamed5(core.Map<core.String, core.List<core.String>> o) {
  unittest.expect(o, unittest.hasLength(2));
  checkUnnamed4(o["x"]);
  checkUnnamed4(o["y"]);
}

core.int buildCounterImportResult = 0;
buildImportResult() {
  var o = new api.ImportResult();
  buildCounterImportResult++;
  if (buildCounterImportResult < 3) {
    o.debug = "foo";
    o.itemId = "foo";
    o.itemSource = "foo";
    o.itemTypeId = "foo";
    o.itemTypeName = "foo";
    o.itemUrl = "foo";
    o.values = buildUnnamed5();
  }
  buildCounterImportResult--;
  return o;
}

checkImportResult(api.ImportResult o) {
  buildCounterImportResult++;
  if (buildCounterImportResult < 3) {
    unittest.expect(o.debug, unittest.equals('foo'));
    unittest.expect(o.itemId, unittest.equals('foo'));
    unittest.expect(o.itemSource, unittest.equals('foo'));
    unittest.expect(o.itemTypeId, unittest.equals('foo'));
    unittest.expect(o.itemTypeName, unittest.equals('foo'));
    unittest.expect(o.itemUrl, unittest.equals('foo'));
    checkUnnamed5(o.values);
  }
  buildCounterImportResult--;
}

buildUnnamed6() {
  var o = new core.List<api.ItemCopy>();
  o.add(buildItemCopy());
  o.add(buildItemCopy());
  return o;
}

checkUnnamed6(core.List<api.ItemCopy> o) {
  unittest.expect(o, unittest.hasLength(2));
  checkItemCopy(o[0]);
  checkItemCopy(o[1]);
}

buildUnnamed7() {
  var o = new core.Map<core.String, core.String>();
  o["x"] = "foo";
  o["y"] = "foo";
  return o;
}

checkUnnamed7(core.Map<core.String, core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o["x"], unittest.equals('foo'));
  unittest.expect(o["y"], unittest.equals('foo'));
}

core.int buildCounterItem = 0;
buildItem() {
  var o = new api.Item();
  buildCounterItem++;
  if (buildCounterItem < 3) {
    o.canDelete = true;
    o.canEdit = true;
    o.copies = buildUnnamed6();
    o.dateAdded = core.DateTime.parse("2002-02-27T14:01:02");
    o.dateUpdated = core.DateTime.parse("2002-02-27T14:01:02");
    o.name = "foo";
    o.readableId = "foo";
    o.type = buildItemType();
    o.typeUuid = "foo";
    o.uuid = "foo";
    o.values = buildUnnamed7();
  }
  buildCounterItem--;
  return o;
}

checkItem(api.Item o) {
  buildCounterItem++;
  if (buildCounterItem < 3) {
    unittest.expect(o.canDelete, unittest.isTrue);
    unittest.expect(o.canEdit, unittest.isTrue);
    checkUnnamed6(o.copies);
    unittest.expect(o.dateAdded, unittest.equals(core.DateTime.parse("2002-02-27T14:01:02")));
    unittest.expect(o.dateUpdated, unittest.equals(core.DateTime.parse("2002-02-27T14:01:02")));
    unittest.expect(o.name, unittest.equals('foo'));
    unittest.expect(o.readableId, unittest.equals('foo'));
    checkItemType(o.type);
    unittest.expect(o.typeUuid, unittest.equals('foo'));
    unittest.expect(o.uuid, unittest.equals('foo'));
    checkUnnamed7(o.values);
  }
  buildCounterItem--;
}

core.int buildCounterItemActionRequest = 0;
buildItemActionRequest() {
  var o = new api.ItemActionRequest();
  buildCounterItemActionRequest++;
  if (buildCounterItemActionRequest < 3) {
    o.action = "foo";
    o.actionerUserUuid = "foo";
  }
  buildCounterItemActionRequest--;
  return o;
}

checkItemActionRequest(api.ItemActionRequest o) {
  buildCounterItemActionRequest++;
  if (buildCounterItemActionRequest < 3) {
    unittest.expect(o.action, unittest.equals('foo'));
    unittest.expect(o.actionerUserUuid, unittest.equals('foo'));
  }
  buildCounterItemActionRequest--;
}

buildUnnamed8() {
  var o = new core.List<core.String>();
  o.add("foo");
  o.add("foo");
  return o;
}

checkUnnamed8(core.List<core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o[0], unittest.equals('foo'));
  unittest.expect(o[1], unittest.equals('foo'));
}

core.int buildCounterItemCopy = 0;
buildItemCopy() {
  var o = new api.ItemCopy();
  buildCounterItemCopy++;
  if (buildCounterItemCopy < 3) {
    o.collection = buildCollection();
    o.collectionUuid = "foo";
    o.eligibleActions = buildUnnamed8();
    o.itemSummary = buildItemSummary();
    o.itemUuid = "foo";
    o.status = "foo";
    o.statusName = "foo";
    o.uniqueId = "foo";
    o.userCanCheckout = true;
    o.userCanEdit = true;
    o.uuid = "foo";
  }
  buildCounterItemCopy--;
  return o;
}

checkItemCopy(api.ItemCopy o) {
  buildCounterItemCopy++;
  if (buildCounterItemCopy < 3) {
    checkCollection(o.collection);
    unittest.expect(o.collectionUuid, unittest.equals('foo'));
    checkUnnamed8(o.eligibleActions);
    checkItemSummary(o.itemSummary);
    unittest.expect(o.itemUuid, unittest.equals('foo'));
    unittest.expect(o.status, unittest.equals('foo'));
    unittest.expect(o.statusName, unittest.equals('foo'));
    unittest.expect(o.uniqueId, unittest.equals('foo'));
    unittest.expect(o.userCanCheckout, unittest.isTrue);
    unittest.expect(o.userCanEdit, unittest.isTrue);
    unittest.expect(o.uuid, unittest.equals('foo'));
  }
  buildCounterItemCopy--;
}

core.int buildCounterItemSummary = 0;
buildItemSummary() {
  var o = new api.ItemSummary();
  buildCounterItemSummary++;
  if (buildCounterItemSummary < 3) {
    o.name = "foo";
    o.thumbnail = "foo";
    o.typeUuid = "foo";
    o.uuid = "foo";
  }
  buildCounterItemSummary--;
  return o;
}

checkItemSummary(api.ItemSummary o) {
  buildCounterItemSummary++;
  if (buildCounterItemSummary < 3) {
    unittest.expect(o.name, unittest.equals('foo'));
    unittest.expect(o.thumbnail, unittest.equals('foo'));
    unittest.expect(o.typeUuid, unittest.equals('foo'));
    unittest.expect(o.uuid, unittest.equals('foo'));
  }
  buildCounterItemSummary--;
}

buildUnnamed9() {
  var o = new core.List<core.String>();
  o.add("foo");
  o.add("foo");
  return o;
}

checkUnnamed9(core.List<core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o[0], unittest.equals('foo'));
  unittest.expect(o[1], unittest.equals('foo'));
}

buildUnnamed10() {
  var o = new core.List<api.Field>();
  o.add(buildField());
  o.add(buildField());
  return o;
}

checkUnnamed10(core.List<api.Field> o) {
  unittest.expect(o, unittest.hasLength(2));
  checkField(o[0]);
  checkField(o[1]);
}

core.int buildCounterItemType = 0;
buildItemType() {
  var o = new api.ItemType();
  buildCounterItemType++;
  if (buildCounterItemType < 3) {
    o.fieldUuids = buildUnnamed9();
    o.fields = buildUnnamed10();
    o.name = "foo";
    o.readableId = "foo";
    o.uuid = "foo";
  }
  buildCounterItemType--;
  return o;
}

checkItemType(api.ItemType o) {
  buildCounterItemType++;
  if (buildCounterItemType < 3) {
    checkUnnamed9(o.fieldUuids);
    checkUnnamed10(o.fields);
    unittest.expect(o.name, unittest.equals('foo'));
    unittest.expect(o.readableId, unittest.equals('foo'));
    unittest.expect(o.uuid, unittest.equals('foo'));
  }
  buildCounterItemType--;
}

buildListOfCollection() {
  var o = new api.ListOfCollection();
  o.add(buildCollection());
  o.add(buildCollection());
  return o;
}

checkListOfCollection(api.ListOfCollection o) {
  unittest.expect(o, unittest.hasLength(2));
  checkCollection(o[0]);
  checkCollection(o[1]);
}

buildListOfIdNamePair() {
  var o = new api.ListOfIdNamePair();
  o.add(buildIdNamePair());
  o.add(buildIdNamePair());
  return o;
}

checkListOfIdNamePair(api.ListOfIdNamePair o) {
  unittest.expect(o, unittest.hasLength(2));
  checkIdNamePair(o[0]);
  checkIdNamePair(o[1]);
}

buildListOfItemCopy() {
  var o = new api.ListOfItemCopy();
  o.add(buildItemCopy());
  o.add(buildItemCopy());
  return o;
}

checkListOfItemCopy(api.ListOfItemCopy o) {
  unittest.expect(o, unittest.hasLength(2));
  checkItemCopy(o[0]);
  checkItemCopy(o[1]);
}

buildUnnamed11() {
  var o = new core.List<core.String>();
  o.add("foo");
  o.add("foo");
  return o;
}

checkUnnamed11(core.List<core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o[0], unittest.equals('foo'));
  unittest.expect(o[1], unittest.equals('foo'));
}

buildMapOfListOfString() {
  var o = new api.MapOfListOfString();
  o["a"] = buildUnnamed11();
  o["b"] = buildUnnamed11();
  return o;
}

checkMapOfListOfString(api.MapOfListOfString o) {
  unittest.expect(o, unittest.hasLength(2));
  checkUnnamed11(o["a"]);
  checkUnnamed11(o["b"]);
}

buildUnnamed12() {
  var o = new core.List<core.int>();
  o.add(42);
  o.add(42);
  return o;
}

checkUnnamed12(core.List<core.int> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o[0], unittest.equals(42));
  unittest.expect(o[1], unittest.equals(42));
}

buildUnnamed13() {
  var o = new core.Map<core.String, core.String>();
  o["x"] = "foo";
  o["y"] = "foo";
  return o;
}

checkUnnamed13(core.Map<core.String, core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o["x"], unittest.equals('foo'));
  unittest.expect(o["y"], unittest.equals('foo'));
}

core.int buildCounterMediaMessage = 0;
buildMediaMessage() {
  var o = new api.MediaMessage();
  buildCounterMediaMessage++;
  if (buildCounterMediaMessage < 3) {
    o.bytes = buildUnnamed12();
    o.cacheControl = "foo";
    o.contentEncoding = "foo";
    o.contentLanguage = "foo";
    o.contentType = "foo";
    o.md5Hash = "foo";
    o.metadata = buildUnnamed13();
    o.updated = core.DateTime.parse("2002-02-27T14:01:02");
  }
  buildCounterMediaMessage--;
  return o;
}

checkMediaMessage(api.MediaMessage o) {
  buildCounterMediaMessage++;
  if (buildCounterMediaMessage < 3) {
    checkUnnamed12(o.bytes);
    unittest.expect(o.cacheControl, unittest.equals('foo'));
    unittest.expect(o.contentEncoding, unittest.equals('foo'));
    unittest.expect(o.contentLanguage, unittest.equals('foo'));
    unittest.expect(o.contentType, unittest.equals('foo'));
    unittest.expect(o.md5Hash, unittest.equals('foo'));
    checkUnnamed13(o.metadata);
    unittest.expect(o.updated, unittest.equals(core.DateTime.parse("2002-02-27T14:01:02")));
  }
  buildCounterMediaMessage--;
}

buildUnnamed14() {
  var o = new core.List<api.ItemSummary>();
  o.add(buildItemSummary());
  o.add(buildItemSummary());
  return o;
}

checkUnnamed14(core.List<api.ItemSummary> o) {
  unittest.expect(o, unittest.hasLength(2));
  checkItemSummary(o[0]);
  checkItemSummary(o[1]);
}

core.int buildCounterPaginatedResponse = 0;
buildPaginatedResponse() {
  var o = new api.PaginatedResponse();
  buildCounterPaginatedResponse++;
  if (buildCounterPaginatedResponse < 3) {
    o.items = buildUnnamed14();
    o.page = 42;
    o.pageCount = 42;
    o.startIndex = 42;
    o.totalCount = 42;
    o.totalPages = 42;
  }
  buildCounterPaginatedResponse--;
  return o;
}

checkPaginatedResponse(api.PaginatedResponse o) {
  buildCounterPaginatedResponse++;
  if (buildCounterPaginatedResponse < 3) {
    checkUnnamed14(o.items);
    unittest.expect(o.page, unittest.equals(42));
    unittest.expect(o.pageCount, unittest.equals(42));
    unittest.expect(o.startIndex, unittest.equals(42));
    unittest.expect(o.totalCount, unittest.equals(42));
    unittest.expect(o.totalPages, unittest.equals(42));
  }
  buildCounterPaginatedResponse--;
}

core.int buildCounterPasswordChangeRequest = 0;
buildPasswordChangeRequest() {
  var o = new api.PasswordChangeRequest();
  buildCounterPasswordChangeRequest++;
  if (buildCounterPasswordChangeRequest < 3) {
    o.currentPassword = "foo";
    o.newPassword = "foo";
  }
  buildCounterPasswordChangeRequest--;
  return o;
}

checkPasswordChangeRequest(api.PasswordChangeRequest o) {
  buildCounterPasswordChangeRequest++;
  if (buildCounterPasswordChangeRequest < 3) {
    unittest.expect(o.currentPassword, unittest.equals('foo'));
    unittest.expect(o.newPassword, unittest.equals('foo'));
  }
  buildCounterPasswordChangeRequest--;
}

core.int buildCounterSearchResult = 0;
buildSearchResult() {
  var o = new api.SearchResult();
  buildCounterSearchResult++;
  if (buildCounterSearchResult < 3) {
    o.debug = "foo";
    o.id = "foo";
    o.thumbnail = "foo";
    o.title = "foo";
    o.url = "foo";
  }
  buildCounterSearchResult--;
  return o;
}

checkSearchResult(api.SearchResult o) {
  buildCounterSearchResult++;
  if (buildCounterSearchResult < 3) {
    unittest.expect(o.debug, unittest.equals('foo'));
    unittest.expect(o.id, unittest.equals('foo'));
    unittest.expect(o.thumbnail, unittest.equals('foo'));
    unittest.expect(o.title, unittest.equals('foo'));
    unittest.expect(o.url, unittest.equals('foo'));
  }
  buildCounterSearchResult--;
}

buildUnnamed15() {
  var o = new core.Map<core.String, core.String>();
  o["x"] = "foo";
  o["y"] = "foo";
  return o;
}

checkUnnamed15(core.Map<core.String, core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o["x"], unittest.equals('foo'));
  unittest.expect(o["y"], unittest.equals('foo'));
}

buildUnnamed16() {
  var o = new core.List<api.SearchResult>();
  o.add(buildSearchResult());
  o.add(buildSearchResult());
  return o;
}

checkUnnamed16(core.List<api.SearchResult> o) {
  unittest.expect(o, unittest.hasLength(2));
  checkSearchResult(o[0]);
  checkSearchResult(o[1]);
}

core.int buildCounterSearchResults = 0;
buildSearchResults() {
  var o = new api.SearchResults();
  buildCounterSearchResults++;
  if (buildCounterSearchResults < 3) {
    o.currentPage = 42;
    o.data = buildUnnamed15();
    o.results = buildUnnamed16();
    o.searchUrl = "foo";
    o.totalPages = 42;
    o.totalResults = 42;
  }
  buildCounterSearchResults--;
  return o;
}

checkSearchResults(api.SearchResults o) {
  buildCounterSearchResults++;
  if (buildCounterSearchResults < 3) {
    unittest.expect(o.currentPage, unittest.equals(42));
    checkUnnamed15(o.data);
    checkUnnamed16(o.results);
    unittest.expect(o.searchUrl, unittest.equals('foo'));
    unittest.expect(o.totalPages, unittest.equals(42));
    unittest.expect(o.totalResults, unittest.equals(42));
  }
  buildCounterSearchResults--;
}

core.int buildCounterSetupRequest = 0;
buildSetupRequest() {
  var o = new api.SetupRequest();
  buildCounterSetupRequest++;
  if (buildCounterSetupRequest < 3) {
    o.adminEmail = "foo";
    o.adminPassword = "foo";
    o.adminUser = "foo";
  }
  buildCounterSetupRequest--;
  return o;
}

checkSetupRequest(api.SetupRequest o) {
  buildCounterSetupRequest++;
  if (buildCounterSetupRequest < 3) {
    unittest.expect(o.adminEmail, unittest.equals('foo'));
    unittest.expect(o.adminPassword, unittest.equals('foo'));
    unittest.expect(o.adminUser, unittest.equals('foo'));
  }
  buildCounterSetupRequest--;
}

core.int buildCounterSetupResponse = 0;
buildSetupResponse() {
  var o = new api.SetupResponse();
  buildCounterSetupResponse++;
  if (buildCounterSetupResponse < 3) {
    o.adminUser = true;
  }
  buildCounterSetupResponse--;
  return o;
}

checkSetupResponse(api.SetupResponse o) {
  buildCounterSetupResponse++;
  if (buildCounterSetupResponse < 3) {
    unittest.expect(o.adminUser, unittest.isTrue);
  }
  buildCounterSetupResponse--;
}

buildUnnamed17() {
  var o = new core.List<core.String>();
  o.add("foo");
  o.add("foo");
  return o;
}

checkUnnamed17(core.List<core.String> o) {
  unittest.expect(o, unittest.hasLength(2));
  unittest.expect(o[0], unittest.equals('foo'));
  unittest.expect(o[1], unittest.equals('foo'));
}

core.int buildCounterTransferRequest = 0;
buildTransferRequest() {
  var o = new api.TransferRequest();
  buildCounterTransferRequest++;
  if (buildCounterTransferRequest < 3) {
    o.itemCopyUuids = buildUnnamed17();
    o.targetCollectionUuid = "foo";
  }
  buildCounterTransferRequest--;
  return o;
}

checkTransferRequest(api.TransferRequest o) {
  buildCounterTransferRequest++;
  if (buildCounterTransferRequest < 3) {
    checkUnnamed17(o.itemCopyUuids);
    unittest.expect(o.targetCollectionUuid, unittest.equals('foo'));
  }
  buildCounterTransferRequest--;
}

buildUnnamed18() {
  var o = new core.List<api.MediaMessage>();
  o.add(buildMediaMessage());
  o.add(buildMediaMessage());
  return o;
}

checkUnnamed18(core.List<api.MediaMessage> o) {
  unittest.expect(o, unittest.hasLength(2));
  checkMediaMessage(o[0]);
  checkMediaMessage(o[1]);
}

core.int buildCounterUpdateItemRequest = 0;
buildUpdateItemRequest() {
  var o = new api.UpdateItemRequest();
  buildCounterUpdateItemRequest++;
  if (buildCounterUpdateItemRequest < 3) {
    o.files = buildUnnamed18();
    o.item = buildItem();
  }
  buildCounterUpdateItemRequest--;
  return o;
}

checkUpdateItemRequest(api.UpdateItemRequest o) {
  buildCounterUpdateItemRequest++;
  if (buildCounterUpdateItemRequest < 3) {
    checkUnnamed18(o.files);
    checkItem(o.item);
  }
  buildCounterUpdateItemRequest--;
}

core.int buildCounterUser = 0;
buildUser() {
  var o = new api.User();
  buildCounterUser++;
  if (buildCounterUser < 3) {
    o.email = "foo";
    o.name = "foo";
    o.password = "foo";
    o.readableId = "foo";
    o.type = "foo";
    o.uuid = "foo";
  }
  buildCounterUser--;
  return o;
}

checkUser(api.User o) {
  buildCounterUser++;
  if (buildCounterUser < 3) {
    unittest.expect(o.email, unittest.equals('foo'));
    unittest.expect(o.name, unittest.equals('foo'));
    unittest.expect(o.password, unittest.equals('foo'));
    unittest.expect(o.readableId, unittest.equals('foo'));
    unittest.expect(o.type, unittest.equals('foo'));
    unittest.expect(o.uuid, unittest.equals('foo'));
  }
  buildCounterUser--;
}


main() {
  unittest.group("obj-schema-BulkItemActionRequest", () {
    unittest.test("to-json--from-json", () {
      var o = buildBulkItemActionRequest();
      var od = new api.BulkItemActionRequest.fromJson(o.toJson());
      checkBulkItemActionRequest(od);
    });
  });


  unittest.group("obj-schema-Collection", () {
    unittest.test("to-json--from-json", () {
      var o = buildCollection();
      var od = new api.Collection.fromJson(o.toJson());
      checkCollection(od);
    });
  });


  unittest.group("obj-schema-CreateItemRequest", () {
    unittest.test("to-json--from-json", () {
      var o = buildCreateItemRequest();
      var od = new api.CreateItemRequest.fromJson(o.toJson());
      checkCreateItemRequest(od);
    });
  });


  unittest.group("obj-schema-Field", () {
    unittest.test("to-json--from-json", () {
      var o = buildField();
      var od = new api.Field.fromJson(o.toJson());
      checkField(od);
    });
  });


  unittest.group("obj-schema-IdNamePair", () {
    unittest.test("to-json--from-json", () {
      var o = buildIdNamePair();
      var od = new api.IdNamePair.fromJson(o.toJson());
      checkIdNamePair(od);
    });
  });


  unittest.group("obj-schema-IdRequest", () {
    unittest.test("to-json--from-json", () {
      var o = buildIdRequest();
      var od = new api.IdRequest.fromJson(o.toJson());
      checkIdRequest(od);
    });
  });


  unittest.group("obj-schema-IdResponse", () {
    unittest.test("to-json--from-json", () {
      var o = buildIdResponse();
      var od = new api.IdResponse.fromJson(o.toJson());
      checkIdResponse(od);
    });
  });


  unittest.group("obj-schema-ImportResult", () {
    unittest.test("to-json--from-json", () {
      var o = buildImportResult();
      var od = new api.ImportResult.fromJson(o.toJson());
      checkImportResult(od);
    });
  });


  unittest.group("obj-schema-Item", () {
    unittest.test("to-json--from-json", () {
      var o = buildItem();
      var od = new api.Item.fromJson(o.toJson());
      checkItem(od);
    });
  });


  unittest.group("obj-schema-ItemActionRequest", () {
    unittest.test("to-json--from-json", () {
      var o = buildItemActionRequest();
      var od = new api.ItemActionRequest.fromJson(o.toJson());
      checkItemActionRequest(od);
    });
  });


  unittest.group("obj-schema-ItemCopy", () {
    unittest.test("to-json--from-json", () {
      var o = buildItemCopy();
      var od = new api.ItemCopy.fromJson(o.toJson());
      checkItemCopy(od);
    });
  });


  unittest.group("obj-schema-ItemSummary", () {
    unittest.test("to-json--from-json", () {
      var o = buildItemSummary();
      var od = new api.ItemSummary.fromJson(o.toJson());
      checkItemSummary(od);
    });
  });


  unittest.group("obj-schema-ItemType", () {
    unittest.test("to-json--from-json", () {
      var o = buildItemType();
      var od = new api.ItemType.fromJson(o.toJson());
      checkItemType(od);
    });
  });


  unittest.group("obj-schema-ListOfCollection", () {
    unittest.test("to-json--from-json", () {
      var o = buildListOfCollection();
      var od = new api.ListOfCollection.fromJson(o.toJson());
      checkListOfCollection(od);
    });
  });


  unittest.group("obj-schema-ListOfIdNamePair", () {
    unittest.test("to-json--from-json", () {
      var o = buildListOfIdNamePair();
      var od = new api.ListOfIdNamePair.fromJson(o.toJson());
      checkListOfIdNamePair(od);
    });
  });


  unittest.group("obj-schema-ListOfItemCopy", () {
    unittest.test("to-json--from-json", () {
      var o = buildListOfItemCopy();
      var od = new api.ListOfItemCopy.fromJson(o.toJson());
      checkListOfItemCopy(od);
    });
  });


  unittest.group("obj-schema-MapOfListOfString", () {
    unittest.test("to-json--from-json", () {
      var o = buildMapOfListOfString();
      var od = new api.MapOfListOfString.fromJson(o.toJson());
      checkMapOfListOfString(od);
    });
  });


  unittest.group("obj-schema-MediaMessage", () {
    unittest.test("to-json--from-json", () {
      var o = buildMediaMessage();
      var od = new api.MediaMessage.fromJson(o.toJson());
      checkMediaMessage(od);
    });
  });


  unittest.group("obj-schema-PaginatedResponse", () {
    unittest.test("to-json--from-json", () {
      var o = buildPaginatedResponse();
      var od = new api.PaginatedResponse.fromJson(o.toJson());
      checkPaginatedResponse(od);
    });
  });


  unittest.group("obj-schema-PasswordChangeRequest", () {
    unittest.test("to-json--from-json", () {
      var o = buildPasswordChangeRequest();
      var od = new api.PasswordChangeRequest.fromJson(o.toJson());
      checkPasswordChangeRequest(od);
    });
  });


  unittest.group("obj-schema-SearchResult", () {
    unittest.test("to-json--from-json", () {
      var o = buildSearchResult();
      var od = new api.SearchResult.fromJson(o.toJson());
      checkSearchResult(od);
    });
  });


  unittest.group("obj-schema-SearchResults", () {
    unittest.test("to-json--from-json", () {
      var o = buildSearchResults();
      var od = new api.SearchResults.fromJson(o.toJson());
      checkSearchResults(od);
    });
  });


  unittest.group("obj-schema-SetupRequest", () {
    unittest.test("to-json--from-json", () {
      var o = buildSetupRequest();
      var od = new api.SetupRequest.fromJson(o.toJson());
      checkSetupRequest(od);
    });
  });


  unittest.group("obj-schema-SetupResponse", () {
    unittest.test("to-json--from-json", () {
      var o = buildSetupResponse();
      var od = new api.SetupResponse.fromJson(o.toJson());
      checkSetupResponse(od);
    });
  });


  unittest.group("obj-schema-TransferRequest", () {
    unittest.test("to-json--from-json", () {
      var o = buildTransferRequest();
      var od = new api.TransferRequest.fromJson(o.toJson());
      checkTransferRequest(od);
    });
  });


  unittest.group("obj-schema-UpdateItemRequest", () {
    unittest.test("to-json--from-json", () {
      var o = buildUpdateItemRequest();
      var od = new api.UpdateItemRequest.fromJson(o.toJson());
      checkUpdateItemRequest(od);
    });
  });


  unittest.group("obj-schema-User", () {
    unittest.test("to-json--from-json", () {
      var o = buildUser();
      var od = new api.User.fromJson(o.toJson());
      checkUser(od);
    });
  });


  unittest.group("resource-CollectionsResourceApi", () {
    unittest.test("method--create", () {

      var mock = new HttpServerMock();
      api.CollectionsResourceApi res = new api.ItemApi(mock).collections;
      var arg_request = buildCollection();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.Collection.fromJson(json);
        checkCollection(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 12), unittest.equals("collections/"));
        pathOffset += 12;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.create(arg_request).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

    unittest.test("method--delete", () {

      var mock = new HttpServerMock();
      api.CollectionsResourceApi res = new api.ItemApi(mock).collections;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 12), unittest.equals("collections/"));
        pathOffset += 12;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.delete(arg_uuid).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--getAllIdsAndNames", () {

      var mock = new HttpServerMock();
      api.CollectionsResourceApi res = new api.ItemApi(mock).collections;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 12), unittest.equals("collections/"));
        pathOffset += 12;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildListOfIdNamePair());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getAllIdsAndNames().then(unittest.expectAsync(((api.ListOfIdNamePair response) {
        checkListOfIdNamePair(response);
      })));
    });

    unittest.test("method--getByUuid", () {

      var mock = new HttpServerMock();
      api.CollectionsResourceApi res = new api.ItemApi(mock).collections;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 12), unittest.equals("collections/"));
        pathOffset += 12;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildCollection());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getByUuid(arg_uuid).then(unittest.expectAsync(((api.Collection response) {
        checkCollection(response);
      })));
    });

    unittest.test("method--update", () {

      var mock = new HttpServerMock();
      api.CollectionsResourceApi res = new api.ItemApi(mock).collections;
      var arg_request = buildCollection();
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.Collection.fromJson(json);
        checkCollection(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 12), unittest.equals("collections/"));
        pathOffset += 12;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.update(arg_request, arg_uuid).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

  });


  unittest.group("resource-ExportResourceApi", () {
    unittest.test("method--exportCollections", () {

      var mock = new HttpServerMock();
      api.ExportResourceApi res = new api.ItemApi(mock).export;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 19), unittest.equals("export/collections/"));
        pathOffset += 19;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildListOfCollection());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.exportCollections().then(unittest.expectAsync(((api.ListOfCollection response) {
        checkListOfCollection(response);
      })));
    });

  });


  unittest.group("resource-FieldsResourceApi", () {
    unittest.test("method--applyTemplate", () {

      var mock = new HttpServerMock();
      api.FieldsResourceApi res = new api.ItemApi(mock).fields;
      var arg_request = buildIdRequest();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.IdRequest.fromJson(json);
        checkIdRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 17), unittest.equals("templates/fields/"));
        pathOffset += 17;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.applyTemplate(arg_request).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

    unittest.test("method--create", () {

      var mock = new HttpServerMock();
      api.FieldsResourceApi res = new api.ItemApi(mock).fields;
      var arg_request = buildField();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.Field.fromJson(json);
        checkField(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("fields/"));
        pathOffset += 7;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.create(arg_request).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

    unittest.test("method--delete", () {

      var mock = new HttpServerMock();
      api.FieldsResourceApi res = new api.ItemApi(mock).fields;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("fields/"));
        pathOffset += 7;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.delete(arg_uuid).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--getAllIdsAndNames", () {

      var mock = new HttpServerMock();
      api.FieldsResourceApi res = new api.ItemApi(mock).fields;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("fields/"));
        pathOffset += 7;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildListOfIdNamePair());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getAllIdsAndNames().then(unittest.expectAsync(((api.ListOfIdNamePair response) {
        checkListOfIdNamePair(response);
      })));
    });

    unittest.test("method--getAllTemplates", () {

      var mock = new HttpServerMock();
      api.FieldsResourceApi res = new api.ItemApi(mock).fields;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 17), unittest.equals("templates/fields/"));
        pathOffset += 17;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildListOfIdNamePair());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getAllTemplates().then(unittest.expectAsync(((api.ListOfIdNamePair response) {
        checkListOfIdNamePair(response);
      })));
    });

    unittest.test("method--getByUuid", () {

      var mock = new HttpServerMock();
      api.FieldsResourceApi res = new api.ItemApi(mock).fields;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("fields/"));
        pathOffset += 7;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildField());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getByUuid(arg_uuid).then(unittest.expectAsync(((api.Field response) {
        checkField(response);
      })));
    });

    unittest.test("method--update", () {

      var mock = new HttpServerMock();
      api.FieldsResourceApi res = new api.ItemApi(mock).fields;
      var arg_request = buildField();
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.Field.fromJson(json);
        checkField(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("fields/"));
        pathOffset += 7;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.update(arg_request, arg_uuid).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

  });


  unittest.group("resource-ImportResourceApi", () {
    unittest.test("method--import", () {

      var mock = new HttpServerMock();
      api.ImportResourceApi res = new api.ItemApi(mock).import;
      var arg_provider = "foo";
      var arg_id = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("import/"));
        pathOffset += 7;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_provider"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset));
        pathOffset = path.length;
        unittest.expect(subPart, unittest.equals("$arg_id"));

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildImportResult());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.import(arg_provider, arg_id).then(unittest.expectAsync(((api.ImportResult response) {
        checkImportResult(response);
      })));
    });

    unittest.test("method--listProviders", () {

      var mock = new HttpServerMock();
      api.ImportResourceApi res = new api.ItemApi(mock).import;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("import/"));
        pathOffset += 7;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildMapOfListOfString());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.listProviders().then(unittest.expectAsync(((api.MapOfListOfString response) {
        checkMapOfListOfString(response);
      })));
    });

    unittest.test("method--search", () {

      var mock = new HttpServerMock();
      api.ImportResourceApi res = new api.ItemApi(mock).import;
      var arg_provider = "foo";
      var arg_query = "foo";
      var arg_page = 42;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("import/"));
        pathOffset += 7;
        index = path.indexOf("/search/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_provider"));
        unittest.expect(path.substring(pathOffset, pathOffset + 8), unittest.equals("/search/"));
        pathOffset += 8;
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset));
        pathOffset = path.length;
        unittest.expect(subPart, unittest.equals("$arg_query"));

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }
        unittest.expect(core.int.parse(queryMap["page"].first), unittest.equals(arg_page));


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildSearchResults());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.search(arg_provider, arg_query, page: arg_page).then(unittest.expectAsync(((api.SearchResults response) {
        checkSearchResults(response);
      })));
    });

  });


  unittest.group("resource-ItemTypesResourceApi", () {
    unittest.test("method--applyTemplate", () {

      var mock = new HttpServerMock();
      api.ItemTypesResourceApi res = new api.ItemApi(mock).itemTypes;
      var arg_request = buildIdRequest();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.IdRequest.fromJson(json);
        checkIdRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 16), unittest.equals("templates/types/"));
        pathOffset += 16;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.applyTemplate(arg_request).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

    unittest.test("method--create", () {

      var mock = new HttpServerMock();
      api.ItemTypesResourceApi res = new api.ItemApi(mock).itemTypes;
      var arg_request = buildItemType();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.ItemType.fromJson(json);
        checkItemType(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("types/"));
        pathOffset += 6;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.create(arg_request).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

    unittest.test("method--delete", () {

      var mock = new HttpServerMock();
      api.ItemTypesResourceApi res = new api.ItemApi(mock).itemTypes;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("types/"));
        pathOffset += 6;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.delete(arg_uuid).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--getAllIdsAndNames", () {

      var mock = new HttpServerMock();
      api.ItemTypesResourceApi res = new api.ItemApi(mock).itemTypes;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("types/"));
        pathOffset += 6;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildListOfIdNamePair());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getAllIdsAndNames().then(unittest.expectAsync(((api.ListOfIdNamePair response) {
        checkListOfIdNamePair(response);
      })));
    });

    unittest.test("method--getAllTemplates", () {

      var mock = new HttpServerMock();
      api.ItemTypesResourceApi res = new api.ItemApi(mock).itemTypes;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 16), unittest.equals("templates/types/"));
        pathOffset += 16;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildListOfIdNamePair());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getAllTemplates().then(unittest.expectAsync(((api.ListOfIdNamePair response) {
        checkListOfIdNamePair(response);
      })));
    });

    unittest.test("method--getByUuid", () {

      var mock = new HttpServerMock();
      api.ItemTypesResourceApi res = new api.ItemApi(mock).itemTypes;
      var arg_uuid = "foo";
      var arg_includeFields = true;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("types/"));
        pathOffset += 6;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }
        unittest.expect(queryMap["includeFields"].first, unittest.equals("$arg_includeFields"));


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildItemType());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getByUuid(arg_uuid, includeFields: arg_includeFields).then(unittest.expectAsync(((api.ItemType response) {
        checkItemType(response);
      })));
    });

    unittest.test("method--update", () {

      var mock = new HttpServerMock();
      api.ItemTypesResourceApi res = new api.ItemApi(mock).itemTypes;
      var arg_request = buildItemType();
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.ItemType.fromJson(json);
        checkItemType(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("types/"));
        pathOffset += 6;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.update(arg_request, arg_uuid).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

  });


  unittest.group("resource-ItemsResourceApi", () {
    unittest.test("method--createItemWithCopy", () {

      var mock = new HttpServerMock();
      api.ItemsResourceApi res = new api.ItemApi(mock).items;
      var arg_request = buildCreateItemRequest();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.CreateItemRequest.fromJson(json);
        checkCreateItemRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("items/"));
        pathOffset += 6;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.createItemWithCopy(arg_request).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

    unittest.test("method--delete", () {

      var mock = new HttpServerMock();
      api.ItemsResourceApi res = new api.ItemApi(mock).items;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("items/"));
        pathOffset += 6;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.delete(arg_uuid).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--getByUuidOrReadableId", () {

      var mock = new HttpServerMock();
      api.ItemsResourceApi res = new api.ItemApi(mock).items;
      var arg_uuidOrReadableId = "foo";
      var arg_includeType = true;
      var arg_includeFields = true;
      var arg_includeCopies = true;
      var arg_includeCopyCollection = true;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("items/"));
        pathOffset += 6;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuidOrReadableId"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }
        unittest.expect(queryMap["includeType"].first, unittest.equals("$arg_includeType"));
        unittest.expect(queryMap["includeFields"].first, unittest.equals("$arg_includeFields"));
        unittest.expect(queryMap["includeCopies"].first, unittest.equals("$arg_includeCopies"));
        unittest.expect(queryMap["includeCopyCollection"].first, unittest.equals("$arg_includeCopyCollection"));


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildItem());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getByUuidOrReadableId(arg_uuidOrReadableId, includeType: arg_includeType, includeFields: arg_includeFields, includeCopies: arg_includeCopies, includeCopyCollection: arg_includeCopyCollection).then(unittest.expectAsync(((api.Item response) {
        checkItem(response);
      })));
    });

    unittest.test("method--getVisibleSummaries", () {

      var mock = new HttpServerMock();
      api.ItemsResourceApi res = new api.ItemApi(mock).items;
      var arg_page = 42;
      var arg_perPage = 42;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("items/"));
        pathOffset += 6;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }
        unittest.expect(core.int.parse(queryMap["page"].first), unittest.equals(arg_page));
        unittest.expect(core.int.parse(queryMap["perPage"].first), unittest.equals(arg_perPage));


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildPaginatedResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getVisibleSummaries(page: arg_page, perPage: arg_perPage).then(unittest.expectAsync(((api.PaginatedResponse response) {
        checkPaginatedResponse(response);
      })));
    });

    unittest.test("method--searchVisible", () {

      var mock = new HttpServerMock();
      api.ItemsResourceApi res = new api.ItemApi(mock).items;
      var arg_query = "foo";
      var arg_page = 42;
      var arg_perPage = 42;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("search/"));
        pathOffset += 7;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_query"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }
        unittest.expect(core.int.parse(queryMap["page"].first), unittest.equals(arg_page));
        unittest.expect(core.int.parse(queryMap["perPage"].first), unittest.equals(arg_perPage));


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildPaginatedResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.searchVisible(arg_query, page: arg_page, perPage: arg_perPage).then(unittest.expectAsync(((api.PaginatedResponse response) {
        checkPaginatedResponse(response);
      })));
    });

    unittest.test("method--updateItem", () {

      var mock = new HttpServerMock();
      api.ItemsResourceApi res = new api.ItemApi(mock).items;
      var arg_request = buildUpdateItemRequest();
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.UpdateItemRequest.fromJson(json);
        checkUpdateItemRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("items/"));
        pathOffset += 6;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.updateItem(arg_request, arg_uuid).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

  });


  unittest.group("resource-ItemsCopiesResourceApi", () {
    unittest.test("method--create", () {

      var mock = new HttpServerMock();
      api.ItemsCopiesResourceApi res = new api.ItemApi(mock).items.copies;
      var arg_request = buildItemCopy();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.ItemCopy.fromJson(json);
        checkItemCopy(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("copies/"));
        pathOffset += 7;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.create(arg_request).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

    unittest.test("method--delete", () {

      var mock = new HttpServerMock();
      api.ItemsCopiesResourceApi res = new api.ItemApi(mock).items.copies;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("copies/"));
        pathOffset += 7;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.delete(arg_uuid).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--getByUuidOrUniqueId", () {

      var mock = new HttpServerMock();
      api.ItemsCopiesResourceApi res = new api.ItemApi(mock).items.copies;
      var arg_uuidOrUniqueId = "foo";
      var arg_includeCollection = true;
      var arg_includeItemSummary = true;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("copies/"));
        pathOffset += 7;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuidOrUniqueId"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }
        unittest.expect(queryMap["includeCollection"].first, unittest.equals("$arg_includeCollection"));
        unittest.expect(queryMap["includeItemSummary"].first, unittest.equals("$arg_includeItemSummary"));


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildItemCopy());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getByUuidOrUniqueId(arg_uuidOrUniqueId, includeCollection: arg_includeCollection, includeItemSummary: arg_includeItemSummary).then(unittest.expectAsync(((api.ItemCopy response) {
        checkItemCopy(response);
      })));
    });

    unittest.test("method--getVisibleForItem", () {

      var mock = new HttpServerMock();
      api.ItemsCopiesResourceApi res = new api.ItemApi(mock).items.copies;
      var arg_itemUuidOrReadableId = "foo";
      var arg_includeCollection = true;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("items/"));
        pathOffset += 6;
        index = path.indexOf("/copies/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_itemUuidOrReadableId"));
        unittest.expect(path.substring(pathOffset, pathOffset + 8), unittest.equals("/copies/"));
        pathOffset += 8;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }
        unittest.expect(queryMap["includeCollection"].first, unittest.equals("$arg_includeCollection"));


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildListOfItemCopy());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getVisibleForItem(arg_itemUuidOrReadableId, includeCollection: arg_includeCollection).then(unittest.expectAsync(((api.ListOfItemCopy response) {
        checkListOfItemCopy(response);
      })));
    });

    unittest.test("method--performAction", () {

      var mock = new HttpServerMock();
      api.ItemsCopiesResourceApi res = new api.ItemApi(mock).items.copies;
      var arg_request = buildItemActionRequest();
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.ItemActionRequest.fromJson(json);
        checkItemActionRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("copies/"));
        pathOffset += 7;
        index = path.indexOf("/action/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 8), unittest.equals("/action/"));
        pathOffset += 8;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.performAction(arg_request, arg_uuid).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--performBulkAction", () {

      var mock = new HttpServerMock();
      api.ItemsCopiesResourceApi res = new api.ItemApi(mock).items.copies;
      var arg_request = buildBulkItemActionRequest();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.BulkItemActionRequest.fromJson(json);
        checkBulkItemActionRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 19), unittest.equals("bulk/copies/action/"));
        pathOffset += 19;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.performBulkAction(arg_request).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--transfer", () {

      var mock = new HttpServerMock();
      api.ItemsCopiesResourceApi res = new api.ItemApi(mock).items.copies;
      var arg_request = buildTransferRequest();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.TransferRequest.fromJson(json);
        checkTransferRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 21), unittest.equals("bulk/copies/transfer/"));
        pathOffset += 21;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.transfer(arg_request).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--update", () {

      var mock = new HttpServerMock();
      api.ItemsCopiesResourceApi res = new api.ItemApi(mock).items.copies;
      var arg_request = buildItemCopy();
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.ItemCopy.fromJson(json);
        checkItemCopy(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 7), unittest.equals("copies/"));
        pathOffset += 7;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.update(arg_request, arg_uuid).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

  });


  unittest.group("resource-SetupResourceApi", () {
    unittest.test("method--apply", () {

      var mock = new HttpServerMock();
      api.SetupResourceApi res = new api.ItemApi(mock).setup;
      var arg_request = buildSetupRequest();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.SetupRequest.fromJson(json);
        checkSetupRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("setup/"));
        pathOffset += 6;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildSetupResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.apply(arg_request).then(unittest.expectAsync(((api.SetupResponse response) {
        checkSetupResponse(response);
      })));
    });

    unittest.test("method--get", () {

      var mock = new HttpServerMock();
      api.SetupResourceApi res = new api.ItemApi(mock).setup;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("setup/"));
        pathOffset += 6;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildSetupResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.get().then(unittest.expectAsync(((api.SetupResponse response) {
        checkSetupResponse(response);
      })));
    });

  });


  unittest.group("resource-UsersResourceApi", () {
    unittest.test("method--changePassword", () {

      var mock = new HttpServerMock();
      api.UsersResourceApi res = new api.ItemApi(mock).users;
      var arg_request = buildPasswordChangeRequest();
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.PasswordChangeRequest.fromJson(json);
        checkPasswordChangeRequest(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("users/"));
        pathOffset += 6;
        index = path.indexOf("/password/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 10), unittest.equals("/password/"));
        pathOffset += 10;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.changePassword(arg_request, arg_uuid).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--create", () {

      var mock = new HttpServerMock();
      api.UsersResourceApi res = new api.ItemApi(mock).users;
      var arg_request = buildUser();
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.User.fromJson(json);
        checkUser(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("users/"));
        pathOffset += 6;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.create(arg_request).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

    unittest.test("method--delete", () {

      var mock = new HttpServerMock();
      api.UsersResourceApi res = new api.ItemApi(mock).users;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("users/"));
        pathOffset += 6;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = "";
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.delete(arg_uuid).then(unittest.expectAsync((_) {}));
    });

    unittest.test("method--getAllIdsAndNames", () {

      var mock = new HttpServerMock();
      api.UsersResourceApi res = new api.ItemApi(mock).users;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("users/"));
        pathOffset += 6;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildListOfIdNamePair());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getAllIdsAndNames().then(unittest.expectAsync(((api.ListOfIdNamePair response) {
        checkListOfIdNamePair(response);
      })));
    });

    unittest.test("method--getBorrowedItems", () {

      var mock = new HttpServerMock();
      api.UsersResourceApi res = new api.ItemApi(mock).users;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("users/"));
        pathOffset += 6;
        index = path.indexOf("/borrowed/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 10), unittest.equals("/borrowed/"));
        pathOffset += 10;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildListOfIdNamePair());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getBorrowedItems(arg_uuid).then(unittest.expectAsync(((api.ListOfIdNamePair response) {
        checkListOfIdNamePair(response);
      })));
    });

    unittest.test("method--getByUuid", () {

      var mock = new HttpServerMock();
      api.UsersResourceApi res = new api.ItemApi(mock).users;
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("users/"));
        pathOffset += 6;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildUser());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getByUuid(arg_uuid).then(unittest.expectAsync(((api.User response) {
        checkUser(response);
      })));
    });

    unittest.test("method--getMe", () {

      var mock = new HttpServerMock();
      api.UsersResourceApi res = new api.ItemApi(mock).users;
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("current_user/"));
        pathOffset += 13;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildUser());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.getMe().then(unittest.expectAsync(((api.User response) {
        checkUser(response);
      })));
    });

    unittest.test("method--update", () {

      var mock = new HttpServerMock();
      api.UsersResourceApi res = new api.ItemApi(mock).users;
      var arg_request = buildUser();
      var arg_uuid = "foo";
      mock.register(unittest.expectAsync((http.BaseRequest req, json) {
        var obj = new api.User.fromJson(json);
        checkUser(obj);

        var path = (req.url).path;
        var pathOffset = 0;
        var index;
        var subPart;
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;
        unittest.expect(path.substring(pathOffset, pathOffset + 13), unittest.equals("api/item/0.1/"));
        pathOffset += 13;
        unittest.expect(path.substring(pathOffset, pathOffset + 6), unittest.equals("users/"));
        pathOffset += 6;
        index = path.indexOf("/", pathOffset);
        unittest.expect(index >= 0, unittest.isTrue);
        subPart = core.Uri.decodeQueryComponent(path.substring(pathOffset, index));
        pathOffset = index;
        unittest.expect(subPart, unittest.equals("$arg_uuid"));
        unittest.expect(path.substring(pathOffset, pathOffset + 1), unittest.equals("/"));
        pathOffset += 1;

        var query = (req.url).query;
        var queryOffset = 0;
        var queryMap = {};
        addQueryParam(n, v) => queryMap.putIfAbsent(n, () => []).add(v);
        parseBool(n) {
          if (n == "true") return true;
          if (n == "false") return false;
          if (n == null) return null;
          throw new core.ArgumentError("Invalid boolean: $n");
        }
        if (query.length > 0) {
          for (var part in query.split("&")) {
            var keyvalue = part.split("=");
            addQueryParam(core.Uri.decodeQueryComponent(keyvalue[0]), core.Uri.decodeQueryComponent(keyvalue[1]));
          }
        }


        var h = {
          "content-type" : "application/json; charset=utf-8",
        };
        var resp = convert.JSON.encode(buildIdResponse());
        return new async.Future.value(stringResponse(200, h, resp));
      }), true);
      res.update(arg_request, arg_uuid).then(unittest.expectAsync(((api.IdResponse response) {
        checkIdResponse(response);
      })));
    });

  });


}

