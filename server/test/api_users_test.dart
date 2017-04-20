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

void main() {
  User adminUser;

  setUp(() async {
    server = await setUpServer();

    adminUser = model.AModel.authenticationOverride;
  });

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
      user.readableId = "spaces in readable ID";
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

  test("Create User", () {
    test("Patron User", () async {
      final User testUser = new User();
      testUser.email = "test@test.com";
      testUser.password = generateUuid();
      testUser.type = UserPrivilege.patron;
      testUser.readableId = "TestPatron";
      testUser.name = "Test Patron";
      final IdResponse response = await api.users.create(testUser);
      validateIdResponse(response);
    });
  });

  group("Get user", () {
    test("Patron User", () async {
      final User testUser = await api.users.getByUuid(adminUser.uuid);
      expect(testUser, isNotNull);
    });
  });

  test("Get all users", () async {
    await createTestUsers(api);
    final List<IdNamePair> users = await api.users.getAllIdsAndNames();
    expect(users, isNotNull);
    expect(users.length == 4, isTrue);
  });

  test("Delete users", () async {
    final Map<String, User> users = await createTestUsers(api);

    await api.users.delete(users[UserPrivilege.patron].uuid);
    expect(api.users.getByUuid(users[UserPrivilege.patron].uuid),
        throwsNotFoundException);
  });

  group("User security", () {
    Map<String, User> users;

    setUp(() async {
      users = await createTestUsers(api);
    });

    group("Create", () {
      String createdUuid;
      setUp(() {
        createdUuid = null;
      });
      test("Unauthenticated", () async {
        model.AModel.authenticationOverride = null;
        expect(api.users.create(createUser()), throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.authenticationOverride = users[UserPrivilege.patron];
        expect(api.users.create(createUser()), throwsForbiddenException);
      });
      test("As checkout", () async {
        model.AModel.authenticationOverride = users[UserPrivilege.checkout];
        expect(api.users.create(createUser()), throwsForbiddenException);
      });
      test("As curator", () async {
        model.AModel.authenticationOverride = users[UserPrivilege.curator];
        expect(api.users.create(createUser()), throwsForbiddenException);
      });
      test("As admin", () async {
        model.AModel.authenticationOverride = adminUser;
        final IdResponse response = await api.users.create(createUser());
        validateIdResponse(response);
        createdUuid = response.uuid;
      });
      tearDown(() async {
        if (createdUuid != null) {
          model.AModel.authenticationOverride = adminUser;
          await api.users.delete(createdUuid);
        }
      });
    });
    group("getByUuid", () {
      test("Unauthenticated", () async {
        model.AModel.authenticationOverride = null;
        expect(
            api.users.getByUuid(adminUser.uuid), throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.authenticationOverride = users[UserPrivilege.patron];
        expect(api.users.getByUuid(adminUser.uuid), throwsForbiddenException);
      });
      test("As checkout", () async {
        model.AModel.authenticationOverride = users[UserPrivilege.checkout];
        final User test = await api.users.getByUuid(adminUser.uuid);
        expect(test, isNotNull);
        expect(test.uuid == adminUser.uuid, isTrue);
        expect(test.name == adminUser.name, isTrue);
      });
      test("As curator", () async {
        model.AModel.authenticationOverride = users[UserPrivilege.curator];
        final User test = await api.users.getByUuid(adminUser.uuid);
        expect(test, isNotNull);
        expect(test.uuid == adminUser.uuid, isTrue);
        expect(test.name == adminUser.name, isTrue);
      });
      test("As admin", () async {
        model.AModel.authenticationOverride = adminUser;
        final User test = await api.users.getByUuid(adminUser.uuid);
        expect(test, isNotNull);
        expect(test.uuid == adminUser.uuid, isTrue);
        expect(test.name == adminUser.name, isTrue);
      });
    });
    group("getAllIdsAndNames", () {
      test("Unauthenticated", () async {
        model.AModel.authenticationOverride = null;
        expect(api.users.getAllIdsAndNames(), throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.authenticationOverride = users[UserPrivilege.patron];
        expect(api.users.getAllIdsAndNames(), throwsForbiddenException);
      });
      test("As checkout", () async {
        model.AModel.authenticationOverride = users[UserPrivilege.checkout];
        final List<IdNamePair> pairs = await api.users.getAllIdsAndNames();
        expect(pairs.length == 4, isTrue);
      });
      test("As curator", () async {
        model.AModel.authenticationOverride = users[UserPrivilege.curator];
        final List<IdNamePair> pairs = await api.users.getAllIdsAndNames();
        expect(pairs.length == 4, isTrue);
      });
      test("As admin", () async {
        model.AModel.authenticationOverride = adminUser;
        final List<IdNamePair> pairs = await api.users.getAllIdsAndNames();
        expect(pairs.length == 4, isTrue);
      });
    });
  });
}
