part of pages;


abstract class AEditablePage {
  @Property(notify: true)
  bool showEditButton = true;

  Future edit();
}