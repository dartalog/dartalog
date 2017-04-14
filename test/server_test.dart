import 'dart:async';

import 'package:dartalog/global.dart';
import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/api/item/item_api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_source;
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/tools.dart';
import 'package:rpc/rpc.dart';
import 'package:test/test.dart';

void main() {
  group("Global tools", () {
    test("generateUuid()", () {
      expect(generateUuid(), isNotEmpty);
    });
    group("isUuid()", () {
      test("Generated uuid", () {
        final String uuid = generateUuid();
        expect(isUuid(uuid), isTrue);
      });
      test("v1 uuid", () {
        expect(isUuid("c100b8fe-1fba-11e7-93ae-92361f002671"), isTrue);
      });
      test("v4 uuid", () {
        expect(isUuid("5c5b7256-b7ce-409e-ba64-a6e774470805"), isTrue);
      });
      test("Invalid uuid", () {
        expect(isUuid("Not a uuid"), isFalse);
      });
    });
    group("StringTools", () {
      group(".isNullOrWhitespace()", () {
        test("null", () {
          expect(StringTools.isNullOrWhitespace(null), isTrue);
        });
        test("empty", () {
          expect(StringTools.isNullOrWhitespace(""), isTrue);
        });
        test("whitespace", () {
          expect(StringTools.isNullOrWhitespace("   "), isTrue);
        });
        test("whitespace with letter", () {
          expect(StringTools.isNullOrWhitespace("  t "), isFalse);
        });
      });
      group(".isNotNullOrWhitespace()", () {
        test("null", () {
          expect(StringTools.isNotNullOrWhitespace(null), isFalse);
        });
        test("empty", () {
          expect(StringTools.isNotNullOrWhitespace(""), isFalse);
        });
        test("whitespace", () {
          expect(StringTools.isNotNullOrWhitespace("   "), isFalse);
        });
        test("whitespace with letter", () {
          expect(StringTools.isNotNullOrWhitespace("  t "), isTrue);
        });
      });
    });
    group("isValidEmail()", () {
      test("null", () {
        expect(() => isValidEmail(null), throwsArgumentError);
      });
      test("empty", () {
        expect(isValidEmail(""), isFalse);
      });
      test("invalid", () {
        expect(isValidEmail("singleWord"), isFalse);
      });
      test("valid", () {
        expect(isValidEmail("test@test.com"), isTrue);
      });
    });
  });

  group("API", () {
    ItemApi api;
    User adminUser;
    final String userPassword = generateUuid();

    setUpAll(() async {
      model.settings.loadSettingsFile("test/server.options");

      model.setup.disableSetup();

      await data_source.nukeDataSource();
      final String uuid = await model.users.createUserWith(
          "TestAdmin", "test@test.com", userPassword, UserPrivilege.admin,
          bypassAuthentication: true);

      adminUser = await model.users.getByUuid(uuid, bypassAuthentication: true);

      api = new ItemApi();
    });

    setUp(() async {
      model.AModel.authenticationOverride = adminUser;
    });

    Collection col;
    String collectionUuid;

    group("User validation", () {
      test("Blank readable ID", () async {
        final User user = createUser();
        user.readableId = "";
        expect(api.users.create(user), throwsDataValidationException);
      });
      test("UUID as readable ID", () async {
        final User user = createUser();
        user.readableId = generateUuid();
        expect(api.users.create(user), throwsDataValidationException);
      });
      test("Spaces in as readable ID", () async {
        final User user = createUser();
        user.readableId = "space in readable ID";
        expect(api.users.create(user), throwsDataValidationException);
      });
      test("Blank password", () async {
        final User user = createUser();
        user.password = "";
        expect(api.users.create(user), throwsDataValidationException);
      });
      test("Blank name", () async {
        final User user = createUser();
        user.name = "";
        expect(api.users.create(user), throwsDataValidationException);
      });
      test("Blank type", () async {
        final User user = createUser();
        user.type = "";
        expect(api.users.create(user), throwsDataValidationException);
      });
      test("Invalid type", () async {
        final User user = createUser();
        user.type = "invalidUserType";
        expect(api.users.create(user), throwsDataValidationException);
      });
      test("Blank email", () async {
        final User user = createUser();
        user.email = "";
        expect(api.users.create(user), throwsDataValidationException);
      });
      test("Invalid email", () async {
        final User user = createUser();
        user.email = "invalidEmail";
        expect(api.users.create(user), throwsDataValidationException);
      });
    });

    User patronUser, curatorUser, checkoutUser;

    group("Create Users", () {
      test("Patron User", () async {
        patronUser = new User();
        patronUser.email = "patron@test.com";
        patronUser.password = generateUuid();
        patronUser.type = UserPrivilege.patron;
        patronUser.readableId = "TestPatron";
        patronUser.name = "Test Patron";
        final IdResponse response = await api.users.create(patronUser);
        validateIdResponse(response);
        patronUser.uuid = response.uuid;
      });

      test("Curator User", () async {
        curatorUser = new User();
        curatorUser.email = "curator@test.com";
        curatorUser.password = generateUuid();
        curatorUser.type = UserPrivilege.patron;
        curatorUser.readableId = "TestCurator";
        curatorUser.name = "Test Curator";
        final IdResponse response = await api.users.create(curatorUser);
        expect(response, isNotNull);
        expect(response.uuid, isNotEmpty);
        curatorUser.uuid = response.uuid;
      });

      test("Checkout User", () async {
        checkoutUser = new User();
        checkoutUser.email = "checkout@test.com";
        checkoutUser.password = generateUuid();
        checkoutUser.type = UserPrivilege.checkout;
        checkoutUser.readableId = "TestCheckout";
        checkoutUser.name = "Test Checkout";
        final IdResponse response = await api.users.create(checkoutUser);
        expect(response, isNotNull);
        expect(response.uuid, isNotEmpty);
        checkoutUser.uuid = response.uuid;
      });
    });

    group("Get user", () {
      test("Patron User", () async {
        patronUser = await api.users.getByUuid(patronUser.uuid);
        expect(patronUser, isNotNull);
      });
      test("Curator User", () async {
        curatorUser = await api.users.getByUuid(curatorUser.uuid);
        expect(curatorUser, isNotNull);
      });
      test("Checkout User", () async {
        checkoutUser = await api.users.getByUuid(checkoutUser.uuid);
        expect(checkoutUser, isNotNull);
      });
    });

    test("Get all users", () async {
      final List<IdNamePair> users = await api.users.getAllIdsAndNames();
      expect(users, isNotNull);
      // At this point only 4 users should be present in the database, be sure to adjust this if additional users are added to the test prior to this0
      expect(users.length == 4, isTrue);
    });

    group("User security", () {
      group("Create", () {
        test("Unauthenticated", () async
        {
          model.AModel.authenticationOverride = null;
          expect(api.users.create(createUser()), throwsUnauthorizedException);
        });
        test("As patron", () async
        {
          model.AModel.authenticationOverride = patronUser;
          expect(api.users.create(createUser()), throwsForbiddenException);
        });
        test("As checkout", () async
        {
          model.AModel.authenticationOverride = checkoutUser;
          expect(api.users.create(createUser()), throwsForbiddenException);
        });
        test("As curator", () async
        {
          model.AModel.authenticationOverride = curatorUser;
          expect(api.users.create(createUser()), throwsForbiddenException);
        });
        test("As admin", () async
        {
          model.AModel.authenticationOverride = adminUser;
          final IdResponse response = await api.users.create(createUser());
          validateIdResponse(response);
        });
      });
      group("getByUuid", (){
        test("Unauthenticated", () async
        {
          model.AModel.authenticationOverride = null;
          expect(api.users.getByUuid(adminUser.uuid), throwsUnauthorizedException);
        });
        test("As patron", () async
        {
          model.AModel.authenticationOverride = patronUser;
          expect(api.users.getByUuid(adminUser.uuid), throwsForbiddenException);
        });
        test("As checkout", () async
        {
          model.AModel.authenticationOverride = checkoutUser;
          expect(api.users.getByUuid(adminUser.uuid), throwsForbiddenException);
        });
        test("As curator", () async
        {
          model.AModel.authenticationOverride = curatorUser;
          expect(api.users.getByUuid(adminUser.uuid), throwsForbiddenException);
        });
        test("As admin", () async
        {
          model.AModel.authenticationOverride = adminUser;
          expect(api.users.getByUuid(adminUser.uuid), throwsForbiddenException);
        });
      });
      group("getAllIdsAndNames", (){
        test("Unauthenticated", () async
        {
          model.AModel.authenticationOverride = null;
          expect(api.users.getAllIdsAndNames(), throwsUnauthorizedException);
        });
        test("As patron", () async
        {
          model.AModel.authenticationOverride = patronUser;
          expect(api.users.getAllIdsAndNames(), throwsForbiddenException);
        });
        test("As checkout", () async
        {
          model.AModel.authenticationOverride = checkoutUser;
          expect(api.users.getAllIdsAndNames(), throwsForbiddenException);
                });
        test("As curator", () async
        {
          model.AModel.authenticationOverride = curatorUser;
          expect(api.users.getAllIdsAndNames(), throwsForbiddenException);
                });
        test("As admin", () async
        {
          model.AModel.authenticationOverride = adminUser;
          expect(api.users.getAllIdsAndNames(), throwsForbiddenException);
        });
      });
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
      expect(
          api.collections.getByUuid(collectionUuid), throwsNotFoundException);
    });

    test("Delete users", () async {
      await api.users.delete(patronUser.uuid);
      expect(api.users.getByUuid(patronUser.uuid), throwsNotFoundException);
      await api.users.delete(curatorUser.uuid);
      expect(api.users.getByUuid(curatorUser.uuid), throwsNotFoundException);
    });

    tearDownAll(() async {
      // TODO: Get this going through the model or API instead
      await data_source.users.deleteByUuid(adminUser.uuid);
    });
  });
}

const String testCollectionName = "TESTCOLLECTION";
const String testFieldName = "TESTFIELD";

final Matcher throwsDataValidationException =
    throwsA(new RpcErrorMatcher<DataValidationException>());
final Matcher throwsForbiddenException =
    throwsA(new RpcErrorMatcher<ForbiddenException>());
final Matcher throwsNotFoundException =
    throwsA(new RpcErrorMatcher<NotFoundException>());
final Matcher throwsUnauthorizedException =
    throwsA(new RpcErrorMatcher<UnauthorizedException>());

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

/// Iterates over [users], each time setting the [User] to the current user and running the [toAwait] function.
///
/// The [users] [Map] should contain key-pair values where the key is the [User] and the [bool] is whether of not running [toAwait] as that user should succeed and not throw a [ForbiddenException].
/// Also runs [toAwait] with no user and checks for an [UnauthorizedException] based on [expectUnauthorizedException].
void testSecurity(Future<Null> toAwait(), Map<User, bool> users,
    bool expectUnauthorizedException)  {
  model.AModel.authenticationOverride = null;

  test("Unauthenticated", () async
  {
    if (expectUnauthorizedException) {
      expect(toAwait, throwsUnauthorizedException);
    } else {
      await toAwait();
    }
  });

  for (User user in users.keys) {
    test(user.name, () async
    {
      model.AModel.authenticationOverride = user;
      if (users[user]) {
        await toAwait();
      } else {
        expect(toAwait, throwsForbiddenException);
      }
    });
  }
}

/// Verifies that the [response] is not null and contains a valid uuid
void validateIdResponse(IdResponse response) {
  expect(response, isNotNull);
  expect(response.uuid, isNotEmpty);
  expect(isUuid(response.uuid), isTrue);
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
