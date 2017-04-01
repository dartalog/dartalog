import 'package:dartalog/global.dart';

import '../../data.dart';

// TODO: Add version tracking for fields to guide updates

final Field asinField = new Field.withValues("ASIN", "asin", stringFieldTypeId,
    uuid: "7fa61c6e-0777-42c2-a40e-8f91e557e53c");
final Field authorField = new Field.withValues(
    "Author", "author", stringFieldTypeId,
    uuid: "f9fed849-1358-4c7f-851c-58e7ae51660e");
final Field backCoverField = new Field.withValues(
    "Back Cover", "backCover", imageFieldTypeId,
    uuid: "dee7ddb9-e1de-461e-aead-550058644666");
final Field frontCoverField = new Field.withValues(
    "Front Cover", "frontCover", imageFieldTypeId,
    uuid: "c3e69ba1-75dc-4166-bff0-839353749a0e");
final Field gamePlatformField = new Field.withValues(
    "Game Platform", "gamePlatform", stringFieldTypeId,
    uuid: "473ab8d8-4930-463a-9750-5fb251ce3a70");
final Field illustratorField = new Field.withValues(
    "Illustrator", "illustrator", stringFieldTypeId,
    uuid: "9e5dafb9-57e5-4c55-b41b-90b15e7cb55f");
final Field isbn10Field = new Field.withValues(
    "ISBN-10", "isbn10", stringFieldTypeId,
    uuid: "ed2bcae4-9625-4b94-a84a-c2fbf63aece6");
final Field isbn13Field = new Field.withValues(
    "ISBN-13", "isbn13", stringFieldTypeId,
    uuid: "a866f30b-8573-4691-a5f1-602384d78791");
final Field issueField = new Field.withValues(
    "Issue", "issue", stringFieldTypeId,
    uuid: "91d5ff3e-883e-4393-b443-b00ea9a05dc7");
final Field mobygamesIdField = new Field.withValues(
    "MobyGames ID", "mobygamesId", numericFieldTypeId,
    uuid: "8f98d342-975d-4e3d-9d4f-032c9ff32e32");
final Field seriesField = new Field.withValues(
    "Series", "series", stringFieldTypeId,
    uuid: "0bca7488-f992-482d-b6fd-6f7da5d6492b");
final Field synopsisField = new Field.withValues(
    "Synopsis", "synopsis", stringFieldTypeId,
    uuid: "abbc84b0-8234-4e65-9d90-c74d6c60028e");
final Field upcField = new Field.withValues("UPC", "upc", stringFieldTypeId,
    uuid: "379fbedf-9a65-4c44-9fe9-45b20f1fd77f");
final Field volumeField = new Field.withValues(
    "Volume", "volume", stringFieldTypeId,
    uuid: "6ac32d87-53be-4c8a-af41-9449c6e74040");
