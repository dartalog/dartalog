part of pages;



abstract class APage<T extends APage> extends AControl {
  APage.created(this.title) : super.created();

  @Property(notify: true)
  String title;

  bool showBackButton = false;

  int lastScrollPosition = 0;

  @Property(notify: true, observer: "routeChanged")
  Map get route => mainApp.pageRoute;

  @Property(notify: true)
  Map routeData;

  @Property(notify: true)
  Map routeParameters;


  void routeChanged(Object oldRoute, String newRoute) {
    mainApp.updatePageRoute(newRoute);
  }

  Future activate() async {
    await super.activate();
  }


  void setTitle(String newTitle) {
    this.title = newTitle;
    set("title", newTitle);
    mainApp.evaluatePage();
  }

  Future goBack() {

  }

  bool evaluate(APage page, bool evaluate(T page)) {
    if(page is T) {
      return evaluate(page);
    }
    return false;
  }
}