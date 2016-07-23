part of pages;


abstract class ASaveablePage {
  @Property(notify: true)
  bool showSaveButton = true;

  Future save();
}