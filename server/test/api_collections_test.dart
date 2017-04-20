import 'package:test/test.dart';
import 'shared/api.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/api/item/item_api.dart';
import 'package:dartalog/api/api.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/model/model.dart' as model;

void main() {
  ItemApi api;
  User adminUser;
  //final Map<String,User> users = <String,User>{};

  setUp(() async {
    api = await setUpApi();
    adminUser = model.AModel.authenticationOverride;
  });

  test("Collection validation", () async {
    // Test blank name
    Collection col = createCollection(adminUser);
    col.name = "";
    expect(api.collections.create(col), throwsDataValidationException);

    // Test blank readableId
    col = createCollection(adminUser);
    col.readableId = "";
    expect(api.collections.create(col), throwsDataValidationException);

    col = createCollection(adminUser);
    col.curatorUuids = null;
    expect(api.collections.create(col), throwsDataValidationException);

    col = createCollection(adminUser);
    col.curatorUuids = <String>[];
    expect(api.collections.create(col), throwsDataValidationException);

    col = createCollection(adminUser);
    col.browserUuids = null;
    expect(api.collections.create(col), throwsDataValidationException);

    // Test invalid user ID
    col = createCollection(adminUser);
    col.browserUuids.add(generateUuid());
    expect(api.collections.create(col), throwsDataValidationException);
    col = createCollection(adminUser);
    col.curatorUuids.add(generateUuid());
    expect(api.collections.create(col), throwsDataValidationException);
  });

  test("Create collection", () async {
    final Collection col = createCollection(adminUser);
    final IdResponse response = await api.collections.create(col);
    expect(response, isNotNull);
    collectionUuid = response.uuid;
    expect(collectionUuid, isNotEmpty);
  });

  test("Get collection by uuid", () async {
    col = await api.collections.getByUuid(collectionUuid);
    expect(col, isNotNull);
    expect(col.name, testCollectionName);
  });

  test("Update collection by uuid", () async {
    final String newName = "$testCollectionName 2";
    final String newReadableId = testCollectionName + generateUuid();
    final bool newPubliclyBrowsable = !col.publiclyBrowsable;

    col.name = newName;
    col.readableId = newReadableId;
    col.publiclyBrowsable = newPubliclyBrowsable;
    await api.collections.update(collectionUuid, col);

    col = await api.collections.getByUuid(collectionUuid);

    expect(col.name, newName);
    expect(col.readableId, newReadableId);
    expect(col.publiclyBrowsable, newPubliclyBrowsable);
  });

  test("Delete collection", () async {
    await api.collections.delete(collectionUuid);
    expect(api.collections.getByUuid(collectionUuid), throwsNotFoundException);
  });
}
