import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:dartalog/api/api.dart';
import 'package:dartalog/client.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/routes.dart';
import 'package:dartalog/services/services.dart';
import 'package:dartalog/views/controls/auth_status_component.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:logging/logging.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';

import '../src/a_page.dart';

@Component(
    selector: 'item-browse',
    providers: const [materialProviders],
    directives: const [
      materialDirectives,
      ROUTER_DIRECTIVES,
      AuthStatusComponent,
    ],
    styleUrls: const ["../../shared.css", "item_browse.css"],
    template: '''
      <auth-status (authedChanged)="onAuthChanged(\$event)"></auth-status>
      <div *ngIf="noItemsFound&&!processing" class="no-items">No Items Found</div>
      <span *ngFor="let i of items" >
      <a [routerLink]="['Item', {id: i.id}]" class="item_card">
          <paper-material class="item_card" data-id="{{i.id}}" title="{{i.name}}" class="container">
              <iron-image class="fit" sizing="cover" style="height:100%;width:100%;"
                    src="{{getThumbnailForImage(i.thumbnail)}}"></iron-image>
                    <div class="item_title">
                        <div>{{i.name}}</div>
                    </div>
            </paper-material>
      </a>
      </span>
    ''')
class ItemBrowseComponent extends APage implements OnInit, OnDestroy {
  static final Logger _log = new Logger("ItemBrowseComponent");
  bool curatorAuth = false;

  bool userLoggedIn;
  final ApiService _api;
  final RouteParams _routeParams;
  final PageControlService _pageControl;
  final Router _router;
  final AuthenticationService _auth;
  final List<ItemSummary> items = <ItemSummary>[];
  String _currentQuery = "";

  StreamSubscription<String> _searchSubscription;

  StreamSubscription<PageActions> _pageActionSubscription;
  StreamSubscription<bool> _authChangedSubscription;
  ItemBrowseComponent(
      this._api, this._routeParams, this._pageControl, this._router, this._auth)
      : super(_pageControl, _auth, _router) {
    _searchSubscription = _pageControl.searchChanged.listen(onSearchChanged);
    _pageActionSubscription =
        _pageControl.pageActionRequested.listen(onPageActionRequested);
    _authChangedSubscription =
        _auth.authStatusChanged.listen(onAuthStatusChange);
    setActions();
  }

  @override
  Logger get loggerImpl => _log;

  bool get noItemsFound => items.isEmpty;

  String getThumbnailForImage(String value) {
    return getImageUrl(value, ImageType.thumbnail);
  }

  @override
  void ngOnDestroy() {
    _searchSubscription.cancel();
    _pageActionSubscription.cancel();
    _authChangedSubscription.cancel();
    _pageControl.reset();
  }

  @override
  void ngOnInit() {
    refresh();
  }

  Future<Null> onAuthChanged(bool status) async {
    await refresh();
    setActions();
  }

  Future<Null> onAuthStatusChange(bool value) async {
    await this.refresh();
  }

  void onPageActionRequested(PageActions action) {
    switch (action) {
      case PageActions.Refresh:
        this.refresh();
        break;
      case PageActions.Add:
        _router.navigate([itemAddRoute.name]);
        break;
      default:
        throw new Exception(
            action.toString() + " not implemented for this page");
    }
  }

  void onSearchChanged(String query) {
    if (_currentQuery != query) {
      this._currentQuery = query;
      _router.navigate([
        itemsSearchRoute.name,
        {queryRouteParameter: query}
      ]);
    }
  }

  Future<Null> refresh() async {
    await performApiCall(() async {
      int page = 0;
      String query = "";
      String routeName = itemsPageRoute.name;
      if (_routeParams.params.containsKey(pageRouteParameter)) {
        page = int.parse(_routeParams.get(pageRouteParameter) ?? '1',
                onError: (_) => 1) -
            1;
      }
      if (_routeParams.params.containsKey(queryRouteParameter)) {
        query = _routeParams.get(queryRouteParameter);
      }

      PaginatedResponse response;
      if (StringTools.isNullOrWhitespace(query)) {
        response = await _api.items.getVisibleSummaries(page: page);
      } else {
        response = await _api.items.searchVisible(query, page: page);
        routeName = itemsSearchPageRoute.name;
      }

      items.clear();
      if (response.items.isNotEmpty) items.addAll(response.items);

      final PaginationInfo info = new PaginationInfo();
      for (int i = 0; i < response.totalPages; i++) {
        final Map<String, String> params = <String, String>{};
        if (StringTools.isNotNullOrWhitespace(query)) {
          params[queryRouteParameter] = query;
        }
        params[pageRouteParameter] = (i + 1).toString();
        info.pageParams.add([routeName, params]);
      }
      info.currentPage = page;
      _pageControl.setPaginationInfo(info);
    });
  }

  void setActions() {
    final List<PageActions> actions = <PageActions>[
      PageActions.Refresh,
      PageActions.Search
    ];
    if (_auth.hasPrivilege(UserPrivilege.curator)) {
      actions.add(PageActions.Add);
    }
    _pageControl.setAvailablePageActions(actions);
  }
}
