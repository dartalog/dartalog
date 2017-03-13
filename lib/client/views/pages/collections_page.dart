import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/data/data.dart';
import 'package:logging/logging.dart';
import 'src/a_page.dart';
@Component(
    selector: 'collections-page',
    directives: const [materialDirectives],
    providers: const [materialProviders],
    template: '''

    <div *ngIf="noItemsFound&&!processing" style="width:100%;text-align: center;margin:16pt;">No Collections Found</div>

    <material-list *ngIf="!noItemsFound">
      <material-list-item *ngFor="let i of items" (trigger)="selectItem(i)" disabled>
        {{i.name}}
      </material-list-item>
    </material-list>

    <modal [visible]="visible">
      <material-dialog class="basic-dialog">
          <h3 header>Edit</h3>
            <form (ngSubmit)="onSubmit()" #editForm="ngForm">
            <p>
              <material-input [(ngModel)]="model.id" ngControl="id" floatingLabel required  autoFocus label="ID"></material-input><br/>
              <material-input [(ngModel)]="model.name" ngControl="name" floatingLabel required  label="Name" ></material-input><br/>
              <input type="submit" style="position: absolute; left: -9999px; width: 1px; height: 1px;"/>
          <b style="color:red">{{errorMessage}}</b>
          </p>
            </form>
          <div footer style="text-align: right">
            <material-yes-no-buttons yesHighlighted
            yesText="Save" (yes)="onSubmit()"
            noText="Cancel" (no)="visible = false"
            [pending]="processing" [yesDisabled]="!editForm.valid">
            </material-yes-no-buttons>
          </div>
      </material-dialog>
    </modal>''')
class CollectionsPage extends APage implements OnInit, OnDestroy {
  static final Logger _log = new Logger("CollectionsPage");
  bool get noItemsFound => items.isEmpty;

  @ViewChild("editForm")
  NgForm form;

  @override
  Logger get loggerImpl => _log;

  ListOfIdNamePair items = new ListOfIdNamePair();

  Collection model = new Collection();

  bool visible = false;

  @Output()
  EventEmitter<bool> visibleChange = new EventEmitter<bool>();

  StreamSubscription<PageActions> _pageActionSubscription;

  final PageControlService _pageControl;
  final ApiService _api;

  CollectionsPage(this._pageControl, this._api): super(_pageControl) {
    _pageControl.setPageTitle("Collections");
    _pageControl.setAvailablePageActions(
        <PageActions>[PageActions.Refresh, PageActions.Add]);
    _pageActionSubscription =
        _pageControl.pageActionRequested.listen(onPageActionRequested);
  }

  @override
  void ngOnDestroy() {
    _pageActionSubscription.cancel();
    _pageControl.reset();
  }

  @override
  void ngOnInit() {
    refresh();
  }
  void onPageActionRequested(PageActions action) {
    switch (action) {
      case PageActions.Refresh:
        this.refresh();
        break;
      default:
        throw new Exception(
            action.toString() + " not implemented for this page");
    }
  }

  Future<Null> onSubmit() async {
    errorMessage = "";
    processing = true;
    try {
      visible = false;
    } on Exception catch (e, st) {
      errorMessage = e.toString();
      _log.severe("logInClicked", e, st);
    } catch (e) {
      final HttpRequest request = e.target;
      if (request != null) {
        String message;
        switch (request.status) {
          case 401:
            message = "Login incorrect";
            break;
          default:
            message = "${request.status} - ${request.statusText} - ${request
                .responseText}";
            break;
        }
        errorMessage = message;
      } else {
        errorMessage = "Unknown error while authenticating";
      }
    } finally {
      processing = false;
    }
  }

  Future<Null> refresh() async {
    try {
      processing = true;
      items.clear();
      items.addAll(await _api.collections.getAllIdsAndNames());
    } catch (e, st) {
      window.alert(e.message);
    } finally {
      processing = false;
    }
  }

  void reset() {
    model = new Collection();
    errorMessage = "";
  }

  void selectItem() {}
}
