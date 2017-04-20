import 'collections_page/collections_page.dart';
import 'fields_page/fields_page.dart';
import 'item_add/item_add_page.dart';
import 'item_browse/item_browse.dart';
import 'item_types_page/item_types_page.dart';
import 'setup/setup_page.dart';
import 'users_page/users_page.dart';

export 'collections_page/collections_page.dart';
export 'fields_page/fields_page.dart';
export 'item_add/item_add_page.dart';
export 'item_browse/item_browse.dart';
export 'item_types_page/item_types_page.dart';
export 'setup/setup_page.dart';
export 'users_page/users_page.dart';

const List<Type> pageDirectives = const <Type>[
  CollectionsPage,
  ItemBrowseComponent,
  FieldsPage,
  ItemTypesPage,
  ItemAddPage,
  SetupPage,
  UsersPage
];
