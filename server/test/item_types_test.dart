import 'package:test/test.dart';
import 'shared/api.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/server.dart';
import 'package:dartalog/api/item/item_api.dart';
import 'package:dartalog/api/api.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/model/model.dart' as model;

Server server;
ItemApi get api => server.itemApi;

Map<String,User> users;
void main() {
  ItemType itemType;

  setUp(() async {
    if (server != null) throw new Exception("Server already exists");

    server = await setUpServer();

    users = await createTestUsers(api);
    final Field f =createField();
    final IdResponse r = await api.fields.create(f);
    itemType = createItemType([r.uuid]);
  });

  tearDown(() async {
    await tearDownServer(server);
    server = null;
  });

  group("Item Type validation", () {

    test("Null name", () async {
      itemType.name = null;
      expect(api.itemTypes.create(itemType), throwsDataValidationException);
    });
    test("Blank name", () async {
      itemType.name = "";
      expect(api.itemTypes.create(itemType), throwsDataValidationException);
    });
    test("Null readableId", () async {
      itemType.readableId = null;
      expect(api.itemTypes.create(itemType), throwsDataValidationException);
    });
    test("Blank readableId", () async {
      itemType.readableId = "";
      expect(api.itemTypes.create(itemType), throwsDataValidationException);
    });

    test("Null fieldUuids", () async {
      itemType.fieldUuids = null;
      expect(api.itemTypes.create(itemType), throwsDataValidationException);
    });
    test("Empty fieldUuids", () async {
      itemType.fieldUuids = <String>[];
      expect(api.itemTypes.create(itemType), throwsDataValidationException);
    });
    test("Invalid fieldUuids", () async {
      itemType.fieldUuids = <String>[generateUuid()];
      expect(api.itemTypes.create(itemType), throwsDataValidationException);
    });

    test("Null isFileType", () async {
      itemType.isFileType = null;
      expect(api.itemTypes.create(itemType), throwsDataValidationException);
    });
  });

  group("Method tests", ()
  {
    test("create()", () async {
      final IdResponse response = await api.itemTypes.create(itemType);
      validateIdResponse(response);
    });

    test("getByUuid()", () async {
      final IdResponse response = await api.itemTypes.create(itemType);
      itemType = await api.itemTypes.getByUuid(response.uuid);
      expect(itemType, isNotNull);
      expect(itemType.name, testItemTypeName);
    });

    test("Update collection by uuid", () async {
      final IdResponse response = await api.itemTypes.create(itemType);
      final String newName = "$testCollectionName 2";
      final String newReadableId = testCollectionName + generateUuid();
      final bool newIsFile = !itemType.isFileType;

      itemType.name = newName;
      itemType.readableId = newReadableId;
      itemType.isFileType = newIsFile;

      await api.itemTypes.update(response.uuid, itemType);

      itemType = await api.itemTypes.getByUuid(response.uuid);

      expect(itemType.name, newName);
      expect(itemType.readableId, newReadableId);
      expect(itemType.isFileType, newIsFile);
    });

    test("Delete collection", () async {
      final IdResponse response = await api.itemTypes.create(itemType);
      await api.collections.delete(response.uuid);
      expect(
          api.collections.getByUuid(response.uuid), throwsNotFoundException);
    });
  });
}
