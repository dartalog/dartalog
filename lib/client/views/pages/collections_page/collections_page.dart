import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/api/api.dart' as api;
import 'package:dartalog/data/data.dart';
import 'package:logging/logging.dart';
import '../src/a_page.dart';
import '../../views.dart';
@Component(
    selector: 'collections-page',
    directives: const [materialDirectives],
    providers: const [materialProviders],
    styleUrls: const ["../../shared.css"],
    templateUrl: 'collections_page.html')
class CollectionsPage extends APage implements OnInit, OnDestroy {
  static final Logger _log = new Logger("CollectionsPage");
  @ViewChild("editForm")
  NgForm form;

  bool userAuthorized;

  List<IdNamePair> items = <IdNamePair>[];

  IdNamePair selectedItem;
  api.Collection model = new api.Collection();

  bool editVisible = false;

  @Output()
  EventEmitter<bool> visibleChange = new EventEmitter<bool>();

  StreamSubscription<PageActions> _pageActionSubscription;

  final PageControlService _pageControl;

  final ApiService _api;

  CollectionsPage(this._pageControl, this._api, AuthenticationService _auth)
      : super(_pageControl, _auth) {
    _pageControl.setPageTitle("Collections");
    _pageControl.setAvailablePageActions(
        <PageActions>[PageActions.Refresh, PageActions.Add]);
    _pageActionSubscription =
        _pageControl.pageActionRequested.listen(onPageActionRequested);
  }
  @override
  Logger get loggerImpl => _log;

  bool get noItemsFound => items.isEmpty;

  @override
  void ngOnDestroy() {
    _pageActionSubscription.cancel();
    _pageControl.reset();
  }

  @override
  void ngOnInit() {
    refresh();
  }

  Future<Null> selectItem(IdNamePair item) async {
    await performApiCall(() async {
      reset();
      model = await _api.collections.getById(item.id);
      selectedItem = item;
      editVisible = true;
    });
  }

  void onPageActionRequested(PageActions action) {
    try {
      switch (action) {
        case PageActions.Refresh:
          this.refresh();
          break;
        default:
          throw new Exception(
              action.toString() + " not implemented for this page");
      }
    } catch(e,st) {
      handleException(e,st);
    }
  }

  Future<Null> onSubmit() async {
    await performApiCall(() async {
      if(selectedItem==null) {
        await _api.collections.create(model);
      } else {
        await _api.collections.update(model,selectedItem.id);
      }
      editVisible = false;
    }, form: form);
  }

  Future<Null> refresh() async {
    await performApiCall(() async {
      editVisible = false;
      items.clear();
      final ListOfIdNamePair data =await _api.collections.getAllIdsAndNames();
      items.addAll(data);
    });
  }

  void reset() {
    model = new api.Collection();
    selectedItem = null;
    errorMessage = "";
  }


}
