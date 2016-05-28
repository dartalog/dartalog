part of pages;



abstract class APage extends AControl {
  APage.created(this.title) : super.created();

  @Property(notify: true)
  String title;

  bool showBackButton = false;

  void setTitle(String newTitle) {
    this.title = newTitle;
    set("title", newTitle);
    mainApp.evaluatePage();
  }
}