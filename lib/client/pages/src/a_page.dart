part of pages;


abstract class APage extends PolymerElement {
  APage.created() : super.created();

  DartalogApi api;

  @observable bool supportsAdding = false;

  @observable String title = "";

  void init(DartalogApi api) {
    this.api = api;
  }

  void addItem() {
    if(supportsAdding) {
      throw new Exception("addItem has not been implemented on this page");
    }
  }

}