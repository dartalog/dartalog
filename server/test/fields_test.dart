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
  Field field;

  setUp(() async {
    if (server != null) throw new Exception("Server already exists");

    server = await setUpServer();

    users = await createTestUsers(api);
    field = createField();
  });

  tearDown(() async {
    await tearDownServer(server);
    server = null;
  });

  group("Field validation", () {
    test("Null name", () async {
      field.name = null;
      expect(api.fields.create(field), throwsDataValidationException);
    });
    test("Blank name", () async {
      field.name = "";
      expect(api.fields.create(field), throwsDataValidationException);
    });
    test("Null readableId", () async {
      field.readableId = null;
      expect(api.fields.create(field), throwsDataValidationException);
    });
    test("Blank readableId", () async {
      field.readableId = "";
      expect(api.fields.create(field), throwsDataValidationException);
    });
    test("Null type", () async {
      field.type = null;
      expect(api.fields.create(field), throwsDataValidationException);
    });
    test("Blank type", () async {
      field.type = "";
      expect(api.fields.create(field), throwsDataValidationException);
    });
    test("Invalid type", () async {
      field.type = "INVALID TYPE";
      expect(api.fields.create(field), throwsDataValidationException);
    });

    test("Null unique", () async {
      field.unique = null;
      expect(api.fields.create(field), throwsDataValidationException);
    });
    test("Null Format", () async {
      field.format = null;
      expect(api.fields.create(field), throwsDataValidationException);
    });
    test("Empty Format", () async {
      field.format = "";
      expect(api.fields.create(field), throwsDataValidationException);
    });
    test("Invalid format", () async {
      field.format = "[0-9]++";
      expect(api.fields.create(field), throwsDataValidationException);
    });
  });

  group("Method tests", ()
  {
    test("create()", () async {
      final IdResponse response = await api.fields.create(field);
      validateIdResponse(response);
    });

    test("getByUuid()", () async {
      final IdResponse response = await api.fields.create(field);
      field = await api.fields.getByUuid(response.uuid);
      expect(field, isNotNull);
      expect(field.name==testCollectionName, isTrue);
    });

    test("Update collection by uuid", () async {
      final IdResponse response = await api.fields.create(field);

      final String newName = "$testCollectionName 2";
      final String newReadableId = testCollectionName + generateUuid();
      final bool newUnique= !field.unique;
      final String newFormat = ".+";

      field.name = newName;
      field.readableId = newReadableId;
      field.unique = newUnique;
      field.format = newFormat;

      await api.fields.update(response.uuid, field);

      field = await api.fields.getByUuid(response.uuid);

      expect(field.name, newName);
      expect(field.readableId, newReadableId);
      expect(field.unique, newUnique);
      expect(field.format, newFormat);
    });

    test("Delete collection", () async {
      final IdResponse response = await api.fields.create(field);
      await api.fields.delete(response.uuid);
      expect(
          api.fields.getByUuid(response.uuid), throwsNotFoundException);
    }, skip: "Not implemented");
  });
}
