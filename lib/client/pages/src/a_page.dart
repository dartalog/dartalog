part of pages;



abstract class APage<T extends APage> extends AControl {
  APage.created(this.title) : super.created();

  @Property(notify: true)
  String title;

  bool showBackButton = false;

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