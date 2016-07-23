part of pages;


abstract class ADeletablePage {
  @Property(notify: true)
  bool showDeleteButton = true;

  Future delete();
}