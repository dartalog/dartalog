part of pages;


abstract class ASearchablePage {
  @Property(notify: true)
  bool showSearch = true;

  @Property(notify: true)
  String searchQuery = "";

  @reflectable
  Future search();
}