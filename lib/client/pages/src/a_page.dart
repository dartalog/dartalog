part of pages;


abstract class APage extends PolymerElement {
  APage.created(this.title) : super.created();

  DartalogApi api;

  @observable String title;

  void activate(DartalogApi api, Map args) {
    this.api = api;
    activateInternal(args);
  }
  void activateInternal(Map args);

}