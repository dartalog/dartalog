import 'package:angular2/router.dart';
import 'package:dartalog/views/pages/pages.dart';

const Route collectionsRoute = const Route(
  path: '/collections',
  name: 'Collections',
  component: CollectionsPage,
);
const Route fieldsRoute = const Route(
  path: '/fields',
  name: 'Fields',
  component: FieldsPage,
);
const Route homeRoute = const Route(
    path: '/',
    name: "Home",
    component: ItemBrowseComponent,
    useAsDefault: true);

const String idRouteParameter = "id";

const Route itemAddRoute =
    const Route(path: '/items/add', name: 'ItemAdd', component: ItemAddPage);

const Route itemsPageRoute = const Route(
    path: '/items/:$pageRouteParameter',
    name: 'ItemsPage',
    component: ItemBrowseComponent);

const Route itemsSearchPageRoute = const Route(
    path: '/items/search/:$queryRouteParameter/:$pageRouteParameter',
    name: 'ItemsSearchPage',
    component: ItemBrowseComponent);

const Route itemsSearchRoute = const Route(
    path: '/items/search/:$queryRouteParameter',
    name: 'ItemsSearch',
    component: ItemBrowseComponent);

const Route itemTypesRoute = const Route(
  path: '/item_types',
  name: 'ItemTypes',
  component: ItemTypesPage,
);

const Route itemViewRoute = const Route(
  path: '/item/:$idRouteParameter',
  name: 'Item',
  component: ItemBrowseComponent,
);

const String pageRouteParameter = "page";

const String queryRouteParameter = "query";

const List<Route> routes = const <Route>[
  homeRoute,
  itemsPageRoute,
  itemsSearchRoute,
  itemsSearchPageRoute,
  itemAddRoute,
  itemViewRoute,
  collectionsRoute,
  fieldsRoute,
  itemTypesRoute,
  setupRoute,
  usersRoute
];

const Route setupRoute = const Route(
  path: '/setup',
  name: 'Setup',
  component: SetupPage,
);

const Route usersRoute = const Route(
  path: '/users',
  name: 'Users',
  component: UsersPage,
);
