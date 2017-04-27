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
  Collection col;

  setUp(() async {
    if (server != null) throw new Exception("Server already exists");

    server = await setUpServer();

    users = await createTestUsers(api);
    col = createCollection(users[UserPrivilege.admin]);
  });

  tearDown(() async {
    await tearDownServer(server);
    server = null;
  });

  group("Collection validation", () {

    test("Null name", () async {
      col.name = null;
      expect(api.collections.create(col), throwsDataValidationException);
    });
    test("Blank name", () async {
      col.name = "";
      expect(api.collections.create(col), throwsDataValidationException);
    });
    test("Null readableId", () async {
      col.readableId = null;
      expect(api.collections.create(col), throwsDataValidationException);
    });
    test("Blank readableId", () async {
      col.readableId = "";
      expect(api.collections.create(col), throwsDataValidationException);
    });

    test("Null curatorUuids", () async {
      col.curatorUuids = null;
      expect(api.collections.create(col), throwsDataValidationException);
    });
    test("Empty curatorUuids", () async {
      col.curatorUuids = <String>[];
      expect(api.collections.create(col), throwsDataValidationException);
    });
    test("Invalid curatorUuid", () async {
      col.curatorUuids.add(generateUuid());
      expect(api.collections.create(col), throwsDataValidationException);
    });
    test("Null browserUuids", () async {
      col.browserUuids = null;
      expect(api.collections.create(col), throwsDataValidationException);
    });
    test("Invalid browserUuid", () async {
      col.browserUuids.add(generateUuid());
      expect(api.collections.create(col), throwsDataValidationException);
    });

  });

  group("Method tests", ()
  {
    test("create()", () async {
      final IdResponse response = await api.collections.create(col);
      validateIdResponse(response);
    });

    test("getByUuid()", () async {
      final IdResponse response = await api.collections.create(col);
      col = await api.collections.getByUuid(response.uuid);
      expect(col, isNotNull);
      expect(col.name==testCollectionName, isTrue);
    });

    test("Update collection by uuid", () async {
      final IdResponse response = await api.collections.create(col);
      final String newName = "$testCollectionName 2";
      final String newReadableId = testCollectionName + generateUuid();
      final bool newPubliclyBrowsable = !col.publiclyBrowsable;

      col.name = newName;
      col.readableId = newReadableId;
      col.publiclyBrowsable = newPubliclyBrowsable;

      await api.collections.update(response.uuid, col);

      col = await api.collections.getByUuid(response.uuid);

      expect(col.name, newName);
      expect(col.readableId, newReadableId);
      expect(col.publiclyBrowsable, newPubliclyBrowsable);
    });

    test("Delete collection", () async {
      final IdResponse response = await api.collections.create(col);
      await api.collections.delete(response.uuid);
      expect(
          api.collections.getByUuid(response.uuid), throwsNotFoundException);
    });
  });
}
