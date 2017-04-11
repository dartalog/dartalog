import 'package:dartalog/global.dart';
import 'package:dartalog/server/api/item/item_api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_source;
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/tools.dart';
import 'package:rpc/rpc.dart';
import 'package:test/test.dart';
import 'package:dartalog/server/api/api.dart';

void main() {
  ItemApi api;
  User adminUser;
  final String userPassword = generateUuid();

  setUp(() async {
    model.settings.loadSettingsFile("test/server.options");

    model.setup.disableSetup();

    await data_source.nukeDataSource();

    final String uuid = await model.users.createUserWith(
        "TESTUSER" + generateUuid(),
        "test@test.com",
        userPassword,
        UserPrivilege.admin,
        bypassAuthentication: true);
    adminUser = await model.users.getByUuid(uuid, bypassAuthentication: true);
    model.AModel.authenticationOverride = adminUser;

    api = new ItemApi();
  });

  group("Global tools", () {
    test("Generate UUID", () {
      generateUuid();
    });
    test("StringTools.isNullOrWhitespace", () {
      expect(StringTools.isNullOrWhitespace(null), isTrue);
      expect(StringTools.isNullOrWhitespace(""), isTrue);
      expect(StringTools.isNullOrWhitespace("   "), isTrue);
      expect(StringTools.isNullOrWhitespace("  t "), isFalse);
    });
    test("StringTools.isNotNullOrWhitespace", () {
      expect(StringTools.isNotNullOrWhitespace(null), isFalse);
      expect(StringTools.isNotNullOrWhitespace(""), isFalse);
      expect(StringTools.isNotNullOrWhitespace("   "), isFalse);
      expect(StringTools.isNotNullOrWhitespace("  t "), isTrue);
    });
    test("isValidEmail", () {
      expect(isValidEmail(""), isFalse);
      expect(isValidEmail("singleWord"), isFalse);
      expect(isValidEmail("test@test.com"), isTrue);
    });
  });

  group("API", () {
    Collection col;
    String collectionUuid;

    //User patronUser;
    //User curatorUser;

    test("User validation", () async {
      User user = createUser();
      user.readableId = "";
      expect(api.users.create(user), isDataValidationException);

      user = createUser();
      user.readableId = generateUuid();
      expect(api.users.create(user), isDataValidationException);

      user = createUser();
      user.password = "";
      expect(api.users.create(user), isDataValidationException);

      user = createUser();
      user.name = "";
      expect(api.users.create(user), isDataValidationException);

      user = createUser();
      user.type = "";
      expect(api.users.create(user), isDataValidationException);

      user = createUser();
      user.type = "invalidUserType";
      expect(api.users.create(user), isDataValidationException);

      user = createUser();
      user.email = "";
      expect(api.users.create(user), isDataValidationException);

      user = createUser();
      user.email = "invalidEmail";
      expect(api.users.create(user), isDataValidationException);
    });

    test("Collection validation", () async {
      // Test blank name
      Collection col = createCollection(adminUser);
      col.name = "";
      expect(api.collections.create(col), isDataValidationException);

      // Test blank readableId
      col = createCollection(adminUser);
      col.readableId = "";
      expect(api.collections.create(col), isDataValidationException);

      col = createCollection(adminUser);
      col.curatorUuids = null;
      expect(api.collections.create(col), isDataValidationException);

      col = createCollection(adminUser);
      col.curatorUuids = <String>[];
      expect(api.collections.create(col), isDataValidationException);

      col = createCollection(adminUser);
      col.browserUuids = null;
      expect(api.collections.create(col), isDataValidationException);

      // Test invalid user ID
      col = createCollection(adminUser);
      col.browserUuids.add(generateUuid());
      expect(api.collections.create(col), isDataValidationException);
      col = createCollection(adminUser);
      col.curatorUuids.add(generateUuid());
      expect(api.collections.create(col), isDataValidationException);
    });

    test("Create collection", () async {
      final Collection col = createCollection(adminUser);
      final IdResponse response =  await api.collections.create(col);
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
      expect(api.collections.getByUuid(collectionUuid), isNotFoundException);
    });
  });

  tearDown(() async {
    // TODO: Get this going through the model or API instead
    await data_source.users.deleteByUuid(adminUser.uuid);
  });
}

const String testCollectionName = "TESTCOLLECTION";
const String testFieldName = "TESTFIELD";

final Matcher isDataValidationException =
    throwsA(new RpcErrorMatcher<DataValidationException>());

final Matcher isNotFoundException =
    throwsA(new RpcErrorMatcher<NotFoundException>());

/// Creates a [Collection] object that should meet all validation requirements.
Collection createCollection(User testUser) {
  final Collection col = new Collection();
  col.name = testCollectionName;
  col.readableId = testCollectionName + generateUuid();
  col.browserUuids = <String>[testUser.uuid];
  col.curatorUuids = <String>[testUser.uuid];
  col.publiclyBrowsable = false;
  return col;
}

/// Creates a [Field] object that should meet all validation requirements.
Field createField() {
  final Field field = new Field.withValues(
      testFieldName, testFieldName + generateUuid(), numericFieldTypeId);
  return field;
}

/// Creates a [User] object with the specified [type] that should meet all validation requirements.
User createUser([String type = UserPrivilege.patron]) {
  final User user = new User();
  user.readableId = "testUser$type" + generateUuid();
  user.name = "TEST $type";
  user.email = "test@test.com";
  user.type = type;
  user.password = generateUuid();
  return user;
}

/// Allows verifying that API-thrown exceptions were originally of a particular [T]ype.
///
/// The API wraps/translates all exceptions to [RpcError] objects to allow consistent communication of errors to the client.
/// This inspects the error details for a descriptor containing the name of the type of the original exception.
class RpcErrorMatcher<T> extends Matcher {
  @override
  Description describe(Description description) =>
      description.add('an instance of RpcError containing a(n) $T');

  @override
  bool matches(dynamic obj, Map<dynamic, dynamic> matchState) {
    if (obj is RpcError) {
      for (RpcErrorDetail detail in obj.errors) {
        if (detail.locationType == "exceptionType" &&
            detail.location == T.toString()) return true;
      }
    }
    return false;
  }
}
