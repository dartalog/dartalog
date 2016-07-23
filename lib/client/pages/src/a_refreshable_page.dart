part of pages;


abstract class ARefreshablePage {
  @Property(notify: true)
  bool showRefreshButton = true;

  @reflectable
  Future refresh();
}