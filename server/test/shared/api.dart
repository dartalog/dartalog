import 'package:rpc/rpc.dart';
import 'package:test/test.dart';
import 'package:dartalog/api/api.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:dartalog/model/model.dart';
import 'dart:async';
import 'package:dartalog/api/item/item_api.dart';
import 'package:dartalog/data_sources/data_sources.dart';
import 'package:dartalog/server.dart';
import 'package:dartalog/data_sources/mongo/mongo.dart';

const String testCollectionName = "TESTCOLLECTION";
const String testFieldName = "TESTFIELD";
const String testAdminPassword = "TESTPASSWORD";
const String testItemTypeName = "TESTITEMTYPE";
const String testItemName = "TESTITEM";

final Matcher isUnauthorizedException =
new RpcErrorMatcher<UnauthorizedException>();
final Matcher isForbiddenException =
new RpcErrorMatcher<ForbiddenException>();

final Matcher throwsDataValidationException =
    throwsA(new RpcErrorMatcher<DataValidationException>());
final Matcher throwsForbiddenException =
    throwsA(isForbiddenException);
final Matcher throwsNotFoundException =
    throwsA(new RpcErrorMatcher<NotFoundException>());
final Matcher throwsUnauthorizedException = throwsA(isUnauthorizedException);

final Matcher throwsNotImplementedException = throwsA(isNotImplementedException);

const Matcher isNotImplementedException = const _NotImplementedException();

class _NotImplementedException extends TypeMatcher {
  const _NotImplementedException() : super("NotImplementedException");
  bool matches(item, Map matchState) => item is NotImplementedException;
}

Future<Null> _nukeDatabase(String connectionString) async {
  final MongoDbConnectionPool pool = new MongoDbConnectionPool(connectionString);
  await pool.databaseWrapper((MongoDatabase db) => db.nukeDatabase());
}

Future<Server> setUpServer() async {
  final String serverUuid = generateUuid();
  final String connectionString = "mongodb://192.168.1.10:27017/dartalog_test_$serverUuid";
  await _nukeDatabase(connectionString);
  disableSetup();

  final Server server = Server.createInstance(connectionString, instanceUuid: serverUuid);

  final String password = testAdminPassword;
  final String uuid = await server.userModel.createUserWith(
      "AdminUser", "test@test.com", password, UserPrivilege.admin,
      bypassAuthentication: true);

  final User adminUser =
      await server.userModel.getByUuid(uuid, bypassAuthentication: true);

  AModel.overrideCurrentUser(adminUser.uuid);

  return server;
}

Future<Null> tearDownServer(Server server) async {
  final MongoDbConnectionPool pool = server.injector.get(MongoDbConnectionPool);
  await pool.closeConnections();
  await _nukeDatabase(server.connectionString);
}

Future<Map<String, User>> createTestUsers(ItemApi api,
    {List<String> types: const <String>[
      UserPrivilege.admin,
      UserPrivilege.curator,
      UserPrivilege.checkout,
      UserPrivilege.patron,
    ]}) async {
  final Map<String, User> output = <String, User>{};
  for (String type in types) {
    final User newUser = new User();
    newUser.email = "$type@test.com";
    newUser.password = generateUuid();
    newUser.type = type;
    newUser.readableId = "${type}User";
    newUser.name = "$type User";
    final IdResponse response = await api.users.create(newUser);
    validateIdResponse(response);
    newUser.uuid = response.uuid;
    output[type] = newUser;
  }
  return output;
}

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

/// Creates a [ItemType] object that should meet all validation requirements.
ItemType createItemType(List<String> fieldUuids) {
  final ItemType itemType = new ItemType.withValues(
      testItemTypeName, testItemTypeName + generateUuid(), fieldUuids);
  return itemType;
}

/// Creates a [Item] object that should meet all validation requirements.
Item createItem(String typeUuid) {
  final Item item = new Item();
  item.typeUuid = typeUuid;
  item.name = testItemName;
  return item;
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

/// Iterates over [getUsers], each time setting the [User] to the current user and running the [toAwait] function.
///
/// The [users] [Map] should contain key-pair values where the key is the [User] and the [bool] is whether of not running [toAwait] as that user should succeed and not throw a [ForbiddenException].
/// Also runs [toAwait] with no user and checks for an [UnauthorizedException] based on [expectUnauthorizedException].
void testSecurity(Future<Null> toAwait(), Map<User, bool> getUsers(),
    bool expectUnauthorizedException) {
  AModel.overrideCurrentUser(null);

  test("Unauthenticated", () async {
    if (expectUnauthorizedException) {
      Future<Null> end = toAwait();
      expect(end, throwsUnauthorizedException);
    } else {
      await toAwait();
    }
  });

  group("User tests", () {
    final Map<User, bool> users = getUsers();
    for (User user in users.keys) {
      test(user.name, () async {
        AModel.overrideCurrentUser(user.uuid);
        if (users[user]) {
          await toAwait();
        } else {
          Future<Null> end = toAwait();
          expect(end, throwsForbiddenException);
        }
      });
    }
  });
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
            detail.location == T.toString())
          return true;
      }
    }
    return false;
  }
}
