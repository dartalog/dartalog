import 'package:dartalog/global.dart';

import '../../data.dart';
import 'fields.dart';

final ItemType blurayItemType = new ItemType.withValues("Blu-Ray", "bluray",
    <String>[seriesField.uuid, frontCoverField.uuid, upcField.uuid],
    id: "cfc164fd-4dba-49c1-a771-bca5078d7876");

final ItemType bookItemType = new ItemType.withValues(
    "Book",
    "book",
    <String>[
      synopsisField.uuid,
      authorField.uuid,
      illustratorField.uuid,
      seriesField.uuid,
      volumeField.uuid,
      frontCoverField.uuid,
      backCoverField.uuid,
      isbn10Field.uuid,
      isbn13Field.uuid,
      upcField.uuid,
    ],
    id: "4f189b5f-c218-469b-be96-2c70f9fab05c");

final ItemType comicBookItemType = new ItemType.withValues(
    "Comic Book",
    "comicBook",
    <String>[
      authorField.uuid,
      synopsisField.uuid,
      illustratorField.uuid,
      seriesField.uuid,
      volumeField.uuid,
      issueField.uuid,
      frontCoverField.uuid,
      backCoverField.uuid,
      upcField.uuid,
    ],
    id: "6463f786-9ee3-49bf-a479-eb4c14d4a4fa");

final ItemType dvdItemType = new ItemType.withValues(
    "DVD", "dvd", <String>[frontCoverField.uuid, seriesField.uuid, upcField.uuid],
    id: "de113a38-fbab-4dc0-90c6-b7a89be06d5b");

final ItemType videoGameItemType = new ItemType.withValues(
    "Video Game",
    "videoGame",
    <String>[
      gamePlatformField.uuid,
      backCoverField.uuid,
      frontCoverField.uuid,
      seriesField.uuid,
      upcField.uuid
    ],
    id: "3274aed8-ae42-4d71-ab27-af83400aec7d");
