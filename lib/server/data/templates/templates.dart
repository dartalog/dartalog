import '../data.dart';
import 'src/fields.dart';
import 'src/item_types.dart';

export 'src/fields.dart';
export 'src/item_types.dart';

final List<Field> fieldTemplates = <Field>[
  asinField,
  authorField,
  backCoverField,
  frontCoverField,
  gamePlatformField,
  illustratorField,
  isbn10Field,
  isbn13Field,
  issueField,
  mobygamesIdField,
  seriesField,
  synopsisField,
  upcField,
  volumeField,
];

final List<ItemType> itemTypeTemplates = <ItemType>[
  bookItemType,
  comicBookItemType,
  blurayItemType,
  dvdItemType,
  videoGameItemType
];
