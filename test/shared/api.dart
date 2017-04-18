import 'package:rpc/rpc.dart';
import 'package:test/test.dart';
import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'dart:async';
import 'package:dartalog/server/api/item/item_api.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_source;

const String testCollectionName = "TESTCOLLECTION";
const String testFieldName = "TESTFIELD";

final Matcher isUnauthorizedException =
    new RpcErrorMatcher<UnauthorizedException>();

final Matcher throwsDataValidationException =
    throwsA(new RpcErrorMatcher<DataValidationException>());
final Matcher throwsForbiddenException =
    throwsA(new RpcErrorMatcher<ForbiddenException>());
final Matcher throwsNotFoundException =
    throwsA(new RpcErrorMatcher<NotFoundException>());
final Matcher throwsUnauthorizedException = throwsA(isUnauthorizedException);

Future<ItemApi> setUpApi() async {
  model.settings.loadSettingsFile("test/server.options");
  model.setup.disableSetup();
  await data_source.nukeDataSource();

  String password = generateUuid();

  final String uuid = await model.users.createUserWith(
      "AdminUser", "test@test.com", password, UserPrivilege.admin,
      bypassAuthentication: true);

  final User adminUser =
      await model.users.getByUuid(uuid, bypassAuthentication: true);
  adminUser.password = password;
  model.AModel.authenticationOverride = adminUser;

  return new ItemApi();
}

Future<Map<String, User>> createTestUsers(ItemApi api,
    {List<String> types: const <String>[
      UserPrivilege.curator,
      UserPrivilege.checkout,
      UserPrivilege.patron
    ]}) async {
  final Map<String, User> output = <String, User>{};
  for (String type in types) {
    User newUser = new User();
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
void testSecurity(Future<Null> toAwait(), Map<User, bool> getUsers(),
    bool expectUnauthorizedException) {
  model.AModel.authenticationOverride = null;

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
        model.AModel.authenticationOverride = user;
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
            detail.location == T.toString()) return true;
      }
    }
    return false;
  }
}
