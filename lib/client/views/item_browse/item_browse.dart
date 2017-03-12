import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/views/controls/auth_status_component.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';

@Component(
    selector: 'item-browse',
    providers: const [],
    directives: const [ROUTER_DIRECTIVES, AuthStatusComponent],
    styles: const [
      '''
                a.item_card paper-material {
                    cursor: pointer;
                    width: 200pt;
                    height: 200pt;
                    margin-left: 4pt;
                    margin-top: 4pt;
                    position: relative;
                    float:left;
                }
                img.item_thumbnail {
                    height: 100px;
                }
                .item_title {
                    position:absolute;
                    bottom:0;
                    left:0;
                    right: 0;

                    height: 16pt;

                    background: linear-gradient(to bottom, rgba(0,0,0,0) 0%, rgba(0,0,0,0.8) 100%);
                    padding: 8pt;
                }
                .item_title div {
                    color: white;
                    font-weight: 100;
                    height: 16pt;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis !important;

                }
                @media(max-width:400pt) {
                    .item_card paper-material {
                        width: calc(100% - 4pt)!important;
                    }
                }

                @media(max-width:600pt) and (min-width:401pt) {
                    .item_card paper-material {
                        width: calc(100% / 2 - 4pt)!important;
                    }
                }
                @media(max-width:800pt) and (min-width:601pt) {
                    .item_card paper-material {
                        width: calc(100% / 3 - 4pt)!important;
                    }
                }
                @media(max-width:1000pt) and (min-width:801pt) {
                    .item_card paper-material {
                        width: calc(100% / 4 - 4pt)!important;
                    }
                }
                @media(max-width:1200pt) and (min-width:1001pt) {
                    .item_card paper-material {
                        width: calc(100% / 5 - 4pt)!important;
                    }
                }
                @media(max-width:1400pt) and (min-width:1201pt) {
                    .item_card paper-material {
                        width: calc(100% / 6 - 4pt)!important;
                    }
                }
                @media(max-width:1600pt) and (min-width:1401pt) {
                    .item_card paper-material {
                        width: calc(100% / 7 - 4pt)!important;
                    }
                }
                @media(max-width:1800pt) and (min-width:1601pt) {
                    .item_card paper-material {
                        width: calc(100% / 8 - 4pt)!important;
                    }
                }
                @media(max-width:2000pt) and (min-width:1801pt) {
                    .item_card paper-material {
                        width: calc(100% / 9 - 4pt)!important;
                    }
                }
                @media(max-width:2200pt) and (min-width:2001pt) {
                    .item_card paper-material {
                        width: calc(100% / 10 - 4pt)!important;
                    }
                }
    '''
    ],
    template: '''
      <div *ngIf="noItemsFound&&!loading" style="width:100%;text-align: center;margin:16pt;">No Items Found</div>
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
      <auth-status (authedChanged)="refresh()"></auth-status>
    ''')
class ItemBrowseComponent implements OnInit, OnDestroy {
  static final Logger _log = new Logger("ItemBrowseComponent");

  bool userLoggedIn;
  bool loading = false;
  final ApiService _api;
  final RouteParams _routeParams;
  final PageControlService _pageControl;
  final Router _router;
  final List<ItemSummary> items = <ItemSummary>[];

  String _currentQuery = "";

  StreamSubscription<String> _searchSubscription;
  StreamSubscription<PageActions> _pageActionSubscription;

  ItemBrowseComponent(
      this._api, this._routeParams, this._pageControl, this._router) {
    _searchSubscription = _pageControl.searchChanged.listen(onSearchChanged);
    _pageActionSubscription = _pageControl.pageActionRequested.listen(onPageActionRequested);
  }

  bool get noItemsFound => items.isEmpty;

  void onPageActionRequested(PageActions action) {
    switch(action) {
      case PageActions.Refresh:
        this.refresh();
        break;
      default:
        throw new Exception(action.toString() + " not implemented for this page");
    }
  }

  String getThumbnailForImage(String value) {
    return getImageUrl(value, ImageType.thumbnail);
  }

  @override
  void ngOnDestroy() {
    _searchSubscription.cancel();
    _pageActionSubscription.cancel();
    _pageControl.reset();
  }

  @override
  void ngOnInit() {
    refresh();
  }

  void onSearchChanged(String query) {
    if (_currentQuery != query) {
      this._currentQuery = query;
      _router.navigate([
        "ItemsSearch",
        {"query": query}
      ]);
    }
  }

  Future<Null> refresh() async {
    try {
      loading = true;
      int page = 0;
      String query = "";
      String routeName = itemsPageRoute;
      if (_routeParams.params.containsKey("page")) {
        page =
            int.parse(_routeParams.get("page") ?? '1', onError: (_) => 1) - 1;
      }
      if (_routeParams.params.containsKey("query")) {
        query = _routeParams.get("query");
      }

      PaginatedResponse response;
      if (StringTools.isNullOrWhitespace(query)) {
        response = await _api.items.getVisibleSummaries(page: page);
      } else {
        response = await _api.items.searchVisible(query, page: page);
        routeName = "ItemsSearchPage";
      }

      items.clear();
      if (response.items.isNotEmpty)
        items.addAll(ItemSummary.convertObjectList(response.items));

      final PaginationInfo info = new PaginationInfo();
      for (int i = 0; i < response.totalPages; i++) {
        final Map<String, String> params = <String, String>{};
        if (StringTools.isNotNullOrWhitespace(query)) {
          params["query"] = query;
        }
        params["page"] = (i + 1).toString();
        info.pageParams.add([routeName, params]);
      }
      info.currentPage = page;
      _pageControl.setPaginationInfo(info);
    } catch (e, st) {
      _log.severe("refresh", e, st);
    } finally {
      loading = false;
    }
  }
}
