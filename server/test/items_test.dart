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
  CreateItemRequest request;
  Item item;

  setUp(() async {
    if (server != null) throw new Exception("Server already exists");

    server = await setUpServer();

    users = await createTestUsers(api);
    final Field f =createField();
    IdResponse r = await api.fields.create(f);
    final ItemType it = createItemType([r.uuid]);
    r = await api.itemTypes.create(it);
    item = createItem(r.uuid);

    final Collection c = createCollection(users[UserPrivilege.admin]);
    r = await api.collections.create(c);

    request = new CreateItemRequest();
    request.item = item;
    request.collectionUuid = r.uuid;
  });

  tearDown(() async {
    await tearDownServer(server);
    server = null;
  });

  group("Item validation", () {
    test("Null name", () async {
      item.name = null;
      expect(api.items.createItem(item), throwsDataValidationException);
    });
    test("Blank name", () async {
      item.name = "";
      expect(api.items.createItem(item), throwsDataValidationException);
    });
    test("Null readableId", () async {
      item.readableId = null;
      expect(api.items.createItem(item), throwsDataValidationException);
    });
    test("Blank readableId", () async {
      item.readableId = "";
      expect(api.items.createItem(item), throwsDataValidationException);
    });

  });

  group("Method tests", ()
  {
    test("create()", () async {
      expect(api.items.create(item), throwsNotImplementedException);
    });

    test("createItem()", () async {
      request.collectionUuid
      api.items.createItem(newItem)
      expect(api.items.create(item), throwsNotImplementedException);
    });

    test("getByUuid()", () async {
      final IdResponse response = await api.items.create(item);
      item = await api.items.getByUuid(response.uuid);
      expect(item, isNotNull);
      expect(item.name, testItemName);
    });

    test("Update collection by uuid", () async {
      final IdResponse response = await api.items.create(item);
      final String newName = "$testCollectionName 2";
      final String newReadableId = testCollectionName + generateUuid();

      item.name = newName;
      item.readableId = newReadableId;

      await api.items.update(response.uuid, item);

      item = await api.items.getByUuid(response.uuid);

      expect(item.name, newName);
      expect(item.readableId, newReadableId);
    });

    test("Delete collection", () async {
      final IdResponse response = await api.items.create(item);
      await api.collections.delete(response.uuid);
      expect(
          api.collections.getByUuid(response.uuid), throwsNotFoundException);
    });
  });
}
