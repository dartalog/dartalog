part of pages;


abstract class ASearchablePage {
  @property
  bool showSearch = true;

  @Property(notify: true)
  String searchQuery = "";

  Future search();
}