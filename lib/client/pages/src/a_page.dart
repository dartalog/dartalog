part of pages;


abstract class APage extends PolymerElement {
  APage.created() : super.created();

  DartalogApi api;

  @observable String title = "";

  void init(DartalogApi api) {
    this.api = api;
  }

}