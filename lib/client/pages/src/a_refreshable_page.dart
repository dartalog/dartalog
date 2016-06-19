part of pages;


abstract class ARefreshablePage {
  bool showRefreshButton = true;
  Future refresh();
}