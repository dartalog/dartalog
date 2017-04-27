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
  setUp(() async {
    if (server != null) throw new Exception("Server already exists");

    server = await setUpServer();
  });

  tearDown(() async {
    await tearDownServer(server);
    server = null;
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
    test("Short password", () async {
      final User user = createUser();
      user.password = "1234567";
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

  group("Method tests", () {
    Map<String,User> users;
    setUp(() async {
      users = await createTestUsers(api);
    });

    test("create()", () async {
      final User testUser = new User();
      testUser.email = "test@test.com";
      testUser.password = generateUuid();
      testUser.type = UserPrivilege.patron;
      testUser.readableId = "TestPatron";
      testUser.name = "Test Patron";
      final IdResponse response = await api.users.create(testUser);
      validateIdResponse(response);
    });
    test("getByUuid()", () async {
      final User testUser = await api.users.getByUuid(users[UserPrivilege.admin].uuid);
      expect(testUser, isNotNull);
    });
    test("getMe()", () async {
      model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
      final User currentUser = await api.users.getMe();
      expect(currentUser, isNotNull);
      expect(currentUser.uuid == users[UserPrivilege.admin].uuid, isTrue);
    });

    test("getBorrowedItems()", () async {
      final List<IdNamePair> items =
          await api.users.getBorrowedItems(users[UserPrivilege.admin].uuid);
      expect(items, isNotNull);
      expect(items.isEmpty, isTrue);
    }, skip: "This function is not yet implemented");

    test("update()", () async {
      final User user = users[UserPrivilege.admin];
      user.name = "New Name";
      final IdResponse response =
          await api.users.update(user.uuid, user);
      validateIdResponse(response);
    });
    test("changePassword()", () async {
      final PasswordChangeRequest request = new PasswordChangeRequest();
      request.currentPassword = users[UserPrivilege.admin].password;
      request.newPassword = "newpassword";
      await api.users.changePassword(users[UserPrivilege.admin].uuid, request);
    });

    test("delete()", () async {
      await api.users.delete(users[UserPrivilege.patron].uuid);
      expect(api.users.getByUuid(users[UserPrivilege.patron].uuid),
          throwsNotFoundException);
    });

    test("getAllIdsAndNames()", () async {
      final List<IdNamePair> users = await api.users.getAllIdsAndNames();
      expect(users, isNotNull);
      expect(users.length == 5, isTrue);
    });
  });

  group("Security tests", () {
    Map<String, User> users;

    setUp(() async {
      users = await createTestUsers(api);
    });

    group("create()", () {
      test("Unauthenticated", () async {
        model.AModel.overrideCurrentUser(null);
        expect(api.users.create(createUser()), throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.patron].uuid);
        expect(api.users.create(createUser()), throwsForbiddenException);
      });
      test("As checkout", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.checkout].uuid);
        expect(api.users.create(createUser()), throwsForbiddenException);
      });
      test("As curator", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.curator].uuid);
        expect(api.users.create(createUser()), throwsForbiddenException);
      });
      test("As admin", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
        final IdResponse response = await api.users.create(createUser());
        validateIdResponse(response);
      });
    });
    group("getByUuid()", () {
      test("Unauthenticated", () async {
        model.AModel.overrideCurrentUser(null);
        expect(
            api.users.getByUuid(users[UserPrivilege.admin].uuid), throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.patron].uuid);
        expect(api.users.getByUuid(users[UserPrivilege.admin].uuid), throwsForbiddenException);
      });
      test("As checkout", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.checkout].uuid);
        final User test = await api.users.getByUuid(users[UserPrivilege.admin].uuid);
        expect(test, isNotNull);
        expect(test.uuid == users[UserPrivilege.admin].uuid, isTrue);
        expect(test.name == users[UserPrivilege.admin].name, isTrue);
      });
      test("As curator", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.curator].uuid);
        final User test = await api.users.getByUuid(users[UserPrivilege.admin].uuid);
        expect(test, isNotNull);
        expect(test.uuid == users[UserPrivilege.admin].uuid, isTrue);
        expect(test.name == users[UserPrivilege.admin].name, isTrue);
      });
      test("As admin", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
        final User test = await api.users.getByUuid(users[UserPrivilege.admin].uuid);
        expect(test, isNotNull);
        expect(test.uuid == users[UserPrivilege.admin].uuid, isTrue);
        expect(test.name == users[UserPrivilege.admin].name, isTrue);
      });
    });

    group("getMe()", () {
      test("Unauthenticated", () async {
        model.AModel.overrideCurrentUser(null);
        expect(
            api.users.getMe(), throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.patron].uuid);
        final User user = await api.users.getMe();
        expect(user, isNotNull);
        expect(user.uuid == users[UserPrivilege.patron].uuid, isTrue);
      });
      test("As checkout", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.checkout].uuid);
        final User user = await api.users.getMe();
        expect(user, isNotNull);
        expect(user.uuid == users[UserPrivilege.checkout].uuid, isTrue);
      });
      test("As curator", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.curator].uuid);
        final User user = await api.users.getMe();
        expect(user, isNotNull);
        expect(user.uuid == users[UserPrivilege.curator].uuid, isTrue);
      });
      test("As admin", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
        final User user = await api.users.getMe();
        expect(user, isNotNull);
        expect(user.uuid ==  users[UserPrivilege.admin].uuid, isTrue);
      });
    });

    group("getBorrowedItems()", () {
      test("Unauthenticated", () async {
        model.AModel.overrideCurrentUser(null);
        expect(api.users.getBorrowedItems(users[UserPrivilege.admin].uuid),
            throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.patron].uuid);
        expect(api.users.getBorrowedItems(users[UserPrivilege.admin].uuid),
            throwsForbiddenException);
      });
      test("As checkout", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.checkout].uuid);
        expect(api.users.getBorrowedItems(users[UserPrivilege.admin].uuid),
            throwsForbiddenException);
      });
      test("As curator", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.curator].uuid);
        expect(api.users.getBorrowedItems(users[UserPrivilege.admin].uuid),
            throwsForbiddenException);
      });
      test("As admin", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
        expect(api.users.getBorrowedItems(users[UserPrivilege.admin].uuid),
            throwsForbiddenException);
      });
    }, skip: "Not yet implemented");

    group("update()", () {
      group("Different user", () {
        User testUser;
        setUp(() async {
          testUser = createUser();
          testUser.name = "NEW NAME";
          await api.users.create(testUser);
        });
        test("Unauthenticated", () async {
          model.AModel.overrideCurrentUser(null);
          expect(api.users.update(testUser.uuid, testUser),
              throwsUnauthorizedException);
        });
        test("As patron", () async {
          model.AModel.overrideCurrentUser(users[UserPrivilege.patron].uuid);
          expect(api.users.update(testUser.uuid, testUser),
              throwsForbiddenException);
        });
        test("As checkout", () async {
          model.AModel.overrideCurrentUser(users[UserPrivilege.checkout].uuid);
          expect(api.users.update(testUser.uuid, testUser),
              throwsForbiddenException);
        });
        test("As curator", () async {
          model.AModel.overrideCurrentUser(users[UserPrivilege.curator].uuid);
          expect(api.users.update(testUser.uuid, testUser),
              throwsForbiddenException);
        });
        test("As admin", () async {
          model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
          await api.users.update(testUser.uuid, testUser);
        });
      });
      group("Self", () {
        test("As patron", () async {
          model.AModel.overrideCurrentUser(users[UserPrivilege.patron].uuid);
          final User user = users[UserPrivilege.patron];
          user.name = "new test name";
          await api.users.update(user.uuid, user);
        });
        test("As checkout", () async {
          model.AModel.overrideCurrentUser(users[UserPrivilege.checkout].uuid);
          final User user = users[UserPrivilege.checkout];
          user.name = "new test name";
          await api.users.update(user.uuid, user);
        });
        test("As curator", () async {
          model.AModel.overrideCurrentUser(users[UserPrivilege.curator].uuid);
          final User user = users[UserPrivilege.curator];
          user.name = "new test name";
          await api.users.update(user.uuid, user);
        });
        test("As admin", () async {
          model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
          final User user = users[UserPrivilege.admin];
          user.name = "new test name";
          await api.users.update(user.uuid, user);
        });
      });
    });

    group("changePassword()", () {
      PasswordChangeRequest request;
      User testUser;
      setUp(() async {
        testUser = createUser();
        request = new PasswordChangeRequest();
        request.currentPassword = testUser.password;
        request.newPassword = generateUuid();
      });
      test("Unauthenticated", () async {
        model.AModel.overrideCurrentUser(null);
        expect(api.users.changePassword(testUser.uuid, request),
            throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.patron].uuid);
        expect(api.users.changePassword(testUser.uuid, request),
            throwsForbiddenException);
      });
      test("As checkout", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.checkout].uuid);
        expect(api.users.changePassword(testUser.uuid, request),
            throwsForbiddenException);
      });
      test("As curator", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.curator].uuid);
        expect(api.users.changePassword(testUser.uuid, request),
            throwsForbiddenException);
      });
      test("As admin", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
        expect(api.users.changePassword(testUser.uuid, request),
            throwsForbiddenException);
      });
    });

    group("delete()", () {
      User testUser;
      setUp(() async {
        testUser = createUser();
      });
      test("Unauthenticated", () async {
        model.AModel.overrideCurrentUser(null);
        expect(api.users.delete(testUser.uuid), throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.patron].uuid);
        expect(api.users.delete(testUser.uuid), throwsForbiddenException);
      });
      test("As checkout", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.checkout].uuid);
        expect(api.users.delete(testUser.uuid), throwsForbiddenException);
      });
      test("As curator", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.curator].uuid);
        expect(api.users.delete(testUser.uuid), throwsForbiddenException);
      });
      test("As admin", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
        await api.users.delete(testUser.uuid);
      });
    });

    group("getAllIdsAndNames()", () {
      test("Unauthenticated", () async {
        model.AModel.overrideCurrentUser(null);
        expect(api.users.getAllIdsAndNames(), throwsUnauthorizedException);
      });
      test("As patron", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.patron].uuid);
        expect(api.users.getAllIdsAndNames(), throwsForbiddenException);
      });
      test("As checkout", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.checkout].uuid);
        final List<IdNamePair> pairs = await api.users.getAllIdsAndNames();
        expect(pairs.length == 5, isTrue);
      });
      test("As curator", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.curator].uuid);
        final List<IdNamePair> pairs = await api.users.getAllIdsAndNames();
        expect(pairs.length == 5, isTrue);
      });
      test("As admin", () async {
        model.AModel.overrideCurrentUser(users[UserPrivilege.admin].uuid);
        final List<IdNamePair> pairs = await api.users.getAllIdsAndNames();
        expect(pairs.length == 5, isTrue);
      });
    });
  });
}
