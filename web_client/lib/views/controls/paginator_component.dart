import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/services/services.dart';
import 'package:logging/logging.dart';

@Component(
    selector: 'paginator',
    styles: const [
      'div.paginator { position:fixed; background-color:white; bottom: 8pt; right:8pt; margin-left:8pt;}'
    ],
    directives: const [ROUTER_DIRECTIVES, materialDirectives],
    providers: const [materialProviders],
    template: '''
    <div class="paginator" *ngIf="pages.isNotEmpty" >
    <material-button *ngIf="isNotFirstPage">Back</material-button>
    <material-button *ngFor="let p of pages; let i = index" [routerLink]="p" style="width:24pt;">{{i+1}}</material-button>
    <material-button *ngIf="isNotLastPage" >Next</material-button>
    </div>
    ''')
class PaginatorComponent implements OnDestroy {
  static final Logger _log = new Logger("PaginatorComponent");

  int currentPage;
  final List<dynamic> pages = <dynamic>[];

  final PageControlService _pageControl;
  StreamSubscription<PaginationInfo> _subscription;

  PaginatorComponent(this._pageControl) {
    _subscription = _pageControl.paginationChanged.listen(onSubscriptionUpdate);
  }

  bool get isNotFirstPage => currentPage > 0;

  bool get isNotLastPage => currentPage < pages.length - 1;

  @override
  void ngOnDestroy() {
    _subscription.cancel();
  }

  void onSubscriptionUpdate(PaginationInfo status) {
    pages.clear();
    currentPage = status.currentPage;
    pages.addAll(status.pageParams);
  }
}
